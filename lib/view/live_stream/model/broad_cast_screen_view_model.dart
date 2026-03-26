import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/live_stream/live_stream.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/common_fun.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/firebase_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/dialog/confirmation_dialog.dart';
import 'package:bubbly/view/live_stream/screen/live_stream_end_screen.dart';
import 'package:bubbly/view/live_stream/widget/gift_sheet.dart';
import 'package:bubbly/view/profile/profile_screen.dart';
import 'package:bubbly/view/wallet/dialog_coins_plan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:wakelock/wakelock.dart';

class BroadCastScreenViewModel extends BaseViewModel {
  SettingData? settingData;

  void init({required bool isBroadCast, required String agoraToken, required String channelName, User? registrationUser}) {
    isHost = isBroadCast;
    _channelName = channelName;
    _agoraToken = agoraToken;
    commentList = [];
    this.registrationUser = registrationUser;
    prefData();
    rtcEngineHandlerCall();
    setupVideoSDKEngine();
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
      notifyListeners();
    });
    Wakelock.enable();
  }

  String _agoraToken = '';
  String _channelName = '';
  User? registrationUser;
  int _localUserID = 0; //  local user uid
  int? _remoteID; //  remote user uid
  bool _isJoined = false; // Indicates if the local user has joined the channel
  bool isHost = true; // Indicates whether the user has joined as a host or audience
  late RtcEngine agoraEngine; // Agora engine instance
  RtcEngineEventHandler? engineEventHandler;
  bool isMic = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController commentController = TextEditingController();
  FocusNode commentFocus = FocusNode();
  List<LiveStreamComment> commentList = [];
  SessionManager pref = SessionManager();
  User? user;
  StreamSubscription<QuerySnapshot<LiveStreamComment>>? commentStream;
  bool startStop = true;
  Timer? timer;
  Stopwatch watch = Stopwatch();
  String elapsedTime = '';
  LiveStreamUser? liveStreamUser;
  DateTime? dateTime;
  Timer? minimumUserLiveTimer;
  int countTimer = 0;
  int maxMinutes = 0;
  InterstitialAd? interstitialAd;

  void rtcEngineHandlerCall() {
    engineEventHandler = RtcEngineEventHandler(
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        _isJoined = true;
        if (isHost) {
          db.collection(FirebaseRes.liveStreamUser).doc(registrationUser?.data?.identity).set(LiveStreamUser(
                fullName: registrationUser?.data?.fullName ?? '',
                isVerified: registrationUser?.data?.isVerify == 1 ? true : false,
                agoraToken: _agoraToken,
                collectedDiamond: 0,
                hostIdentity: registrationUser?.data?.identity ?? '',
                id: DateTime.now().millisecondsSinceEpoch,
                joinedUser: [],
                userId: registrationUser?.data?.userId ?? -1,
                userImage: registrationUser?.data?.userProfile ?? '',
                userName: registrationUser?.data?.userName ?? '',
                watchingCount: 0,
                followers: registrationUser?.data?.followersCount,
              ).toJson());
        }
        notifyListeners();
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        _remoteID = remoteUid;
        notifyListeners();
      },
      onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        print('onUserOffline');
        if (Get.isBottomSheetOpen == true) {
          Get.back();
        }
        _remoteID = null;
        agoraEngine.leaveChannel();
        agoraEngine.release();

        if (interstitialAd != null) {
          interstitialAd?.show().then((value) {
            Get.back();
          });
        } else {
          Get.back();
        }
      },
      onLeaveChannel: (connection, stats) {
        if (isHost) {
          Get.off(LivestreamEndScreen());
        }
      },
    );
  }

  Widget videoPanel() {
    if (!_isJoined) {
      return LoaderDialog();
    } else if (isHost) {
      // Local user joined as a host
      return AgoraVideoView(
        controller: VideoViewController(rtcEngine: agoraEngine, canvas: VideoCanvas(uid: _localUserID, sourceType: VideoSourceType.videoSourceCameraPrimary)),
      );
    } else {
      return _remoteID != null
          ? AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: agoraEngine,
                canvas: VideoCanvas(uid: _remoteID),
                connection: RtcConnection(channelId: _channelName),
              ),
            )
          : SizedBox();
    }
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();

    await agoraEngine.initialize(RtcEngineContext(appId: settingData?.agoraAppId));

    // Set the video configuration
    VideoEncoderConfiguration videoConfig = VideoEncoderConfiguration(frameRate: liveFrameRate, dimensions: VideoDimensions(width: liveWeight, height: liveHeight));

    // Apply the configuration
    await agoraEngine.setVideoEncoderConfiguration(videoConfig);

    await agoraEngine.enableVideo();

    join();

    // Register the event handler
    if (engineEventHandler != null) {
      agoraEngine.registerEventHandler(engineEventHandler!);
    }
  }

  void join() async {
    // Set channel options
    ChannelMediaOptions options;

    // Set channel profile and client role
    if (isHost) {
      startWatch();
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
      await agoraEngine.startPreview();
    } else {
      options = const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleAudience,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      );
    }
    await agoraEngine.joinChannel(token: _agoraToken, channelId: _channelName, options: options, uid: _localUserID);
    notifyListeners();
  }

  void onEndButtonClick() {
    Get.dialog(
      ConfirmationDialog(
          title1: LKey.areYouSure.tr,
          title2: 'You want to end the live video.',
          onPositiveTap: () {
            Get.back();
            leave();
          },
          aspectRatio: 2),
      barrierDismissible: true,
    );
  }

  void leave() async {
    _isJoined = false;
    _remoteID = null;
    notifyListeners();
    liveStreamData();
    agoraEngine
        .leaveChannel(
      options: const LeaveChannelOptions(),
    )
        .then((value) async {
      if (isHost) {
        db.collection(FirebaseRes.liveStreamUser).doc(_channelName).delete();
        final batch = db.batch();
        var collection = db.collection(FirebaseRes.liveStreamUser).doc(_channelName).collection(FirebaseRes.comment);
        var snapshots = await collection.get();
        for (var doc in snapshots.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        stopWatch();
        interstitialAd?.show();
      }
    });
  }

  void prefData() async {
    await pref.initPref();
    user = pref.getUser();
    settingData = pref.getSetting()?.data;
    maxMinutes = (settingData?.liveTimeout ?? 0) * 60;
    initFirebase();
    getProfile();
  }

  void initFirebase() {
    db
        .collection(FirebaseRes.liveStreamUser)
        .doc(_channelName)
        .withConverter(
          fromFirestore: LiveStreamUser.fromFireStore,
          toFirestore: (LiveStreamUser value, options) => value.toFireStore(),
        )
        .snapshots()
        .listen((event) {
      liveStreamUser = event.data();
      if (isHost) {
        minimumUserLiveTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
          countTimer++;
          if (countTimer == maxMinutes && liveStreamUser!.watchingCount! <= (settingData?.liveMinViewers ?? -1)) {
            timer.cancel();
            leave();
          }
          if (countTimer == maxMinutes) {
            countTimer = 0;
          }
        });
        notifyListeners();
      }
      notifyListeners();
    });
    commentStream = db
        .collection(FirebaseRes.liveStreamUser)
        .doc(_channelName)
        .collection(FirebaseRes.comment)
        .orderBy(FirebaseRes.id, descending: true)
        .withConverter(
          fromFirestore: LiveStreamComment.fromFireStore,
          toFirestore: (LiveStreamComment value, options) {
            return value.toFireStore();
          },
        )
        .snapshots()
        .listen((event) {
      commentList = [];
      for (int i = 0; i < event.docs.length; i++) {
        commentList.add(event.docs[i].data());
      }
      notifyListeners();
    });
  }

  onComment() {
    if (commentController.text.isEmpty) {
      return;
    }
    onCommentSend(commentType: FirebaseRes.msg, msg: commentController.text.trim());
    commentController.clear();
    commentFocus.unfocus();
  }

  Future<void> onCommentSend({required String commentType, required String msg}) async {
    await db.collection(FirebaseRes.liveStreamUser).doc(_channelName).collection(FirebaseRes.comment).add(LiveStreamComment(
            id: DateTime.now().millisecondsSinceEpoch,
            userName: user?.data?.userName ?? '',
            userImage: user?.data?.userProfile ?? '',
            userId: user?.data?.userId ?? -1,
            fullName: user?.data?.fullName ?? '',
            comment: msg,
            commentType: commentType,
            isVerify: user?.data?.isVerify == 1 ? true : false)
        .toJson());
  }

  void flipCamera() {
    agoraEngine.switchCamera();
  }

  void onMuteUnMute() {
    isMic = !isMic;
    notifyListeners();
    agoraEngine.muteLocalAudioStream(isMic);
  }

  void audienceExit() async {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }

    await db.collection(FirebaseRes.liveStreamUser).doc(_channelName).update(
      {FirebaseRes.watchingCount: liveStreamUser != null && liveStreamUser?.watchingCount != 0 ? liveStreamUser!.watchingCount! - 1 : 0},
    );
    _remoteID = null;
    agoraEngine.leaveChannel();

    if (interstitialAd != null) {
      interstitialAd?.show().then((value) {
        Get.back();
      });
    } else {
      Get.back();
    }
  }

  void onGiftTap(BuildContext context) {
    getProfile();
    Get.bottomSheet(
      GiftSheet(
        onAddShortzzTap: () {
          Get.bottomSheet(
            DialogCoinsPlan(),
            backgroundColor: Colors.transparent,
          );
        },
        settingData: settingData,
        user: user,
        onGiftSend: (gifts) async {
          Navigator.pop(context);
          int value = liveStreamUser!.collectedDiamond! + gifts!.coinPrice!;
          await db.collection(FirebaseRes.liveStreamUser).doc(_channelName).update({FirebaseRes.collectedDiamond: value});
          await ApiService().sendCoin('${gifts.coinPrice}', '${liveStreamUser?.userId}').then((value) {
            getProfile();
          });
          onCommentSend(commentType: FirebaseRes.image, msg: gifts.image ?? '');
        },
      ),
      backgroundColor: Colors.transparent,
    );
  }

  void getProfile() async {
    await ApiService().getProfile(SessionManager.userId.toString()).then((value) {
      user = value;
      notifyListeners();
    });
  }

  void onUserTap(BuildContext context) async {
    _remoteID = null;
    db.collection(FirebaseRes.liveStreamUser).doc(_channelName).update(
      {FirebaseRes.watchingCount: liveStreamUser != null && liveStreamUser?.watchingCount != null ? liveStreamUser!.watchingCount! - 1 : 0},
    );
    await agoraEngine.leaveChannel();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(type: 1, userId: '${liveStreamUser?.userId ?? -1}'),
      ),
    );
  }

  void startWatch() {
    startStop = false;
    watch.start();
    timer = Timer.periodic(const Duration(milliseconds: 100), updateTime);
    dateTime = DateTime.now();
    notifyListeners();
  }

  updateTime(Timer timer) {
    if (watch.isRunning) {
      elapsedTime = transformMilliSeconds(watch.elapsedMilliseconds);
      notifyListeners();
    }
  }

  void stopWatch() {
    startStop = true;
    watch.stop();
    setTime();
    notifyListeners();
  }

  void setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    elapsedTime = transformMilliSeconds(timeSoFar);
    notifyListeners();
  }

  String transformMilliSeconds(int milliseconds) {
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  Future<void> liveStreamData() async {
    pref.saveString(KeyRes.liveStreamingTiming, elapsedTime);
    pref.saveString(KeyRes.liveStreamWatchingUser, "${liveStreamUser?.joinedUser?.length}");
    pref.saveString(KeyRes.liveStreamCollected, "${liveStreamUser?.collectedDiamond}");
    pref.saveString(KeyRes.liveStreamProfile, "${liveStreamUser?.userImage}");
  }

  @override
  void dispose() {
    commentController.dispose();
    commentStream?.cancel();
    agoraEngine.unregisterEventHandler(engineEventHandler!);
    Wakelock.disable();
    timer?.cancel();
    minimumUserLiveTimer?.cancel();
    super.dispose();
  }
}
