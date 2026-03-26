import 'dart:async';
import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/chat/chat.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/common_fun.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/firebase_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/chat_screen/widget/add_btn_sheet.dart';
import 'package:bubbly/view/chat_screen/widget/bottom_input_bar.dart';
import 'package:bubbly/view/chat_screen/widget/chat_area.dart';
import 'package:bubbly/view/chat_screen/widget/image_video_msg_screen.dart';
import 'package:bubbly/view/chat_screen/widget/top_bar_area.dart';
import 'package:bubbly/view/dialog/confirmation_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final Conversation? user;

  static String notificationID = '';

  const ChatScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Conversation? conversation;
  User? user;
  User? conversationUserData;
  SessionManager sessionManager = SessionManager();
  var db = FirebaseFirestore.instance;
  late DocumentReference drReceiver;
  late DocumentReference drSender;
  late CollectionReference drChatMessage;
  List<String> notDeletedIdentity = [];
  Map<String, List<ChatMessage>>? grouped;
  ChatUser? receiverUser;
  StreamSubscription<QuerySnapshot<ChatMessage>>? chatStream;
  TextEditingController textMsgController = TextEditingController();
  List<ChatMessage> chatData = [];
  List<String> timeStamp = [];
  bool isLongPress = false;
  bool? isBlockFromOther = false;
  StreamSubscription<DocumentSnapshot<Conversation>>? blockFromOtherStream;
  String deletedId = '';

  @override
  void initState() {
    conversation = widget.user;
    ChatScreen.notificationID = conversation?.conversationId ?? '';
    setState(() {});
    getProfile();
    prefData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            TopBarArea(user: conversation, conversation: conversation),
            ChatArea(
              chatData: grouped,
              onLongPress: onLongPress,
              timeStamp: timeStamp,
            ),
            BottomInputBar(
              msgController: textMsgController,
              onShareBtnTap: () {
                if (isBlockFromOther == true) {
                  CommonUI.showToast(msg: LKey.youAreBlockFromOther.tr);
                } else {
                  onShareBtnTap();
                }
              },
              onAddBtnTap: () {
                if (isBlockFromOther == true) {
                  CommonUI.showToast(msg: LKey.youAreBlockFromOther.tr);
                } else {
                  onAddBtnTap();
                }
              },
              onCameraTap: () {
                if (isBlockFromOther == true) {
                  CommonUI.showToast(msg: LKey.youAreBlockFromOther.tr);
                } else {
                  onCameraTap(context);
                }
              },
              timeStamp: timeStamp,
              onDeleteBtnClick: onDeleteBtnClick,
              cancelBtnClick: onCancelBtnClick,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  void onCameraTap(BuildContext context) async {
    File? images;
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        preferredCameraDevice: CameraDevice.front);
    if (image == null || image.path.isEmpty) return;
    images = File(image.path);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImageVideoMsgScreen(
          image: images?.path,
          onIVSubmitClick: ({text}) {
            CommonUI.showLoader(context);
            ApiService().filePath(filePath: images).then((value) {
              firebaseMsgUpdate(
                  msgType: FirebaseRes.image,
                  image: value.path,
                  video: null,
                  textMessage: text);
            }).then((value) {
              Navigator.pop(context);
              Navigator.pop(context);
            });
          },
        );
      },
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void onShareBtnTap() {
    if (textMsgController.text.trim() != '') {
      firebaseMsgUpdate(
              msgType: FirebaseRes.msg,
              textMessage: textMsgController.text.trim())
          .then((value) {
        textMsgController.clear();
      });
    }
  }

  String dateFormat(DateTime time) {
    String hour = time.hour.toString();
    String minute = time.minute.toString().padLeft(2, '0');
    bool isAm = (time.hour * 60) > 719 ? false : true;
    String timeStr = '$hour:$minute ${isAm ? 'am' : 'pm'}';
    return timeStr;
  }

  void prefData() async {
    await sessionManager.initPref();
    user = sessionManager.getUser();
    initFireStore();
  }

  void getProfile() {
    ApiService().getProfile('${conversation?.user?.userid}').then((value) {
      conversationUserData = value;
      // print(value.data?.toJson());
      setState(() {});
    });
    ApiService().getProfile(SessionManager.userId.toString()).then((value) {
      user = value;
      setState(() {});
    });
  }

  void initFireStore() {
    drReceiver = db
        .collection(FirebaseRes.userChatList)
        .doc(conversation?.user?.userIdentity)
        .collection(FirebaseRes.userList)
        .doc(user?.data?.identity);

    drSender = db
        .collection(FirebaseRes.userChatList)
        .doc(user?.data?.identity)
        .collection(FirebaseRes.userList)
        .doc(conversation?.user?.userIdentity);

    drSender
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Conversation.fromJson(snapshot.data()!),
          toFirestore: (Conversation value, options) {
            return value.toJson();
          },
        )
        .get()
        .then(
      (value) async {
        if (value.data() != null && value.data()?.conversationId != null) {
          conversation?.setConversationId(value.data()?.conversationId);
        }
        drChatMessage = db
            .collection(FirebaseRes.chat)
            .doc(conversation?.conversationId)
            .collection(FirebaseRes.chat);
        getChat();
      },
    );
  }

  void getChat() async {
    await drReceiver
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Conversation.fromJson(snapshot.data()!),
          toFirestore: (Conversation value, options) {
            return value.toJson();
          },
        )
        .get()
        .then(
      (value) {
        receiverUser = value.data()?.user;
      },
    );

    await drSender
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Conversation.fromJson(snapshot.data()!),
          toFirestore: (Conversation value, options) {
            return value.toJson();
          },
        )
        .get()
        .then((value) {
      deletedId = value.data()?.deletedId.toString() ?? '';
      setState(() {});
    });

    chatStream = drChatMessage
        .where(FirebaseRes.noDeletedId, arrayContains: user?.data?.identity)
        .where(FirebaseRes.time,
            isGreaterThan: deletedId.isEmpty ? 0.0 : double.parse(deletedId))
        .orderBy(FirebaseRes.time, descending: true)
        .withConverter(
          fromFirestore: ChatMessage.fromFireStore,
          toFirestore: (ChatMessage value, options) {
            return value.toFireStore();
          },
        )
        .snapshots()
        .listen(
      (element) async {
        chatData = [];
        for (int i = 0; i < element.docs.length; i++) {
          chatData.add(element.docs[i].data());
        }
        grouped = groupBy<ChatMessage, String>(
          chatData,
          (message) {
            final now = DateTime.now();
            DateTime time =
                DateTime.fromMillisecondsSinceEpoch(message.time!.toInt());
            if (DateFormat("dd MMM yyyy").format(DateTime.now()) ==
                DateFormat("dd MMM yyyy").format(time)) {
              return 'Today';
            }
            if (DateFormat("dd MMM yyyy")
                    .format(DateTime(now.year, now.month, now.day - 1)) ==
                DateFormat("dd MMM yyyy").format(time)) {
              return 'Yesterday';
            } else {
              return DateFormat("dd MMM yyyy").format(time);
            }
          },
        );
        setState(() {});
      },
    );
  }

  Future<void> firebaseMsgUpdate(
      {required String msgType,
      String? textMessage,
      String? image,
      String? video}) async {
    var time = DateTime.now().millisecondsSinceEpoch;
    notDeletedIdentity = [];
    notDeletedIdentity.addAll(
        ['${user?.data?.identity}', '${conversation?.user?.userIdentity}']);

    drChatMessage.doc(time.toString()).set(
          ChatMessage(
            notDeletedIdentities: notDeletedIdentity,
            senderUser: ChatUser(
              username: user?.data?.userName,
              userFullName: user?.data?.fullName,
              date: time.toDouble(),
              isNewMsg: true,
              userid: user?.data?.userId,
              userIdentity: user?.data?.identity,
              image: user?.data?.userProfile,
              isVerified: user?.data?.isVerify == 1 ? true : false,
            ),
            msgType: msgType,
            msg: textMessage?.trim(),
            image: image,
            video: video,
            id: conversation?.user?.userid?.toString(),
            time: time.toDouble(),
          ).toJson(),
        );

    if (chatData.isEmpty && deletedId.isEmpty) {
      Map con = conversation?.toJson() ?? {};
      con[FirebaseRes.lastMsg] =
          CommonFun.getLastMsg(type: msgType, message: textMessage ?? '');
      drSender.set(con);
      drReceiver.set(
        Conversation(
          block: false,
          blockFromOther: false,
          conversationId: conversation?.conversationId,
          deletedId: '',
          isDeleted: false,
          isMute: false,
          lastMsg:
              CommonFun.getLastMsg(type: msgType, message: textMessage ?? ''),
          newMsg: textMessage,
          time: time.toDouble(),
          user: ChatUser(
            username: user?.data?.userName,
            userIdentity: user?.data?.identity,
            userid: user?.data?.userId,
            userFullName: user?.data?.fullName ?? '',
            isNewMsg: false,
            image: user?.data?.userProfile,
            date: time.toDouble(),
            isVerified: user?.data?.isVerify == 1 ? true : false,
          ),
        ).toJson(),
      );
    } else {
      receiverUser?.isNewMsg = true;
      drReceiver.update(
        {
          FirebaseRes.isDeleted: false,
          FirebaseRes.time: time.toDouble(),
          FirebaseRes.lastMsg:
              CommonFun.getLastMsg(type: msgType, message: textMessage ?? ''),
          FirebaseRes.user: receiverUser?.toJson(),
        },
      );
      // sender update
      drSender.update(
        {
          FirebaseRes.isDeleted: false,
          FirebaseRes.time: time.toDouble(),
          FirebaseRes.lastMsg:
              CommonFun.getLastMsg(type: msgType, message: textMessage ?? '')
        },
      );
    }
    ApiService().pushNotification(
        title: user?.data?.fullName ?? appName,
        body: CommonFun.getLastMsg(type: msgType, message: textMessage ?? ''),
        token: '${conversationUserData?.data?.deviceToken}',
        data: {'NotificationID': conversation?.conversationId});
  }

  void onAddBtnTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddBtnSheet(
          fireBaseMsg: ({imagePath, msg, msgType, videoPath}) {
            firebaseMsgUpdate(
                msgType: msgType ?? '',
                image: imagePath,
                video: msgType == FirebaseRes.video ? videoPath : null,
                textMessage: msg);
          },
        );
      },
    );
  }

  void onCancelBtnClick() {
    timeStamp = [];
    setState(() {});
  }

  void onDeleteBtnClick() {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
            title1: LKey.deleteMessage.tr,
            title2: LKey.areYouSureYouWantToDeleteThisMessage.tr,
            onPositiveTap: () {
              Navigator.pop(context);
              onDeleteYesBtnClick();
            },
            positiveText: LKey.delete.tr,
            aspectRatio: 1.8);
      },
    );
  }

  void onDeleteYesBtnClick() {
    for (int i = 0; i < timeStamp.length; i++) {
      drChatMessage.doc(timeStamp[i]).update(
        {
          FirebaseRes.noDeletedId:
              FieldValue.arrayRemove(['${user?.data?.identity}'])
        },
      );
      chatData
          .removeWhere((element) => element.time.toString() == timeStamp[i]);
    }
    timeStamp = [];
    setState(() {});
  }

  void onLongPress(ChatMessage? data) {
    if (!timeStamp.contains('${data?.time?.round()}')) {
      timeStamp.add('${data?.time?.round()}');
    } else {
      timeStamp.remove('${data?.time?.round()}');
    }
    isLongPress = true;
    setState(() {});
  }

  @override
  void dispose() {
    drSender
        .withConverter(
          fromFirestore: (snapshot, options) =>
              Conversation.fromJson(snapshot.data()!),
          toFirestore: (Conversation value, options) {
            return value.toJson();
          },
        )
        .get()
        .then(
      (value) {
        var senderUser = value.data()?.user;
        senderUser?.isNewMsg = false;
        drSender.update(
          {
            FirebaseRes.user: senderUser?.toJson(),
          },
        );
      },
    );
    chatStream?.cancel();
    blockFromOtherStream?.cancel();
    ChatScreen.notificationID = '';
    super.dispose();
  }
}
