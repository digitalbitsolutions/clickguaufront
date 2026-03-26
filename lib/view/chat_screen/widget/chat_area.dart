import 'package:bubbly/modal/chat/chat.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/firebase_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/chat_screen/widget/image_preview.dart';
import 'package:bubbly/view/chat_screen/widget/video_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatArea extends StatelessWidget {
  final Map<String, List<ChatMessage>>? chatData;
  final Function(ChatMessage? chat) onLongPress;
  final List<String> timeStamp;

  const ChatArea(
      {Key? key,
      required this.chatData,
      required this.onLongPress,
      required this.timeStamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Expanded(
        child: ListView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: chatData != null ? chatData?.keys.length : 0,
          reverse: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            String? date = chatData?.keys.elementAt(index) ?? '';
            List<ChatMessage>? messages = chatData?[date];
            return Column(
              children: [
                _alertView(data: date, isDarkMode: myLoading.isDark),
                ListView.builder(
                  itemCount: messages?.length,
                  reverse: true,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemBuilder: (context, index) {
                    return yourMsg(
                        data: messages?[index],
                        context: context,
                        isDarkMode: myLoading.isDark);
                  },
                ),
              ],
            );
          },
        ),
      );
    });
  }

  Widget yourMsg(
      {ChatMessage? data,
      required BuildContext context,
      required bool isDarkMode}) {
    bool selected = timeStamp.contains('${data?.time?.round()}');
    bool isMe = data?.senderUser?.userid == SessionManager.userId;
    return InkWell(
      onLongPress: () {
        onLongPress(data);
      },
      onTap: () {
        if (timeStamp.isNotEmpty) {
          onLongPress(data);
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 2),
        foregroundDecoration: BoxDecoration(
          color: selected ? Colors.red.withOpacity(0.1) : Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: data?.senderUser?.userid == SessionManager.userId
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            isMe ? _dateTimeMessage(data) : SizedBox(),
            isMe ? const SizedBox(width: 10) : SizedBox(),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isMe ? ColorRes.colorPink : ColorRes.colorPrimary),
              child: data?.msgType == FirebaseRes.image
                  ? imageMessage(data, context, isDarkMode)
                  : data?.msgType == FirebaseRes.video
                      ? videoMessage(data, context, isDarkMode)
                      : _textMessage(data, context),
            ),
            !isMe ? const SizedBox(width: 10) : SizedBox(),
            !isMe ? _dateTimeMessage(data) : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _textMessage(ChatMessage? data, BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 1.4),
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: Text(
          data?.msg ?? '',
          style: const TextStyle(
              color: ColorRes.white, fontFamily: FontRes.fNSfUiRegular),
        ),
      ),
    );
  }

  Widget _dateTimeMessage(ChatMessage? data) {
    return Text(
      DateFormat("h:mm a").format(
        DateTime.fromMillisecondsSinceEpoch(
          data!.time!.toInt(),
        ),
      ),
      style: const TextStyle(
        color: ColorRes.colorTextLight,
        fontSize: 12,
      ),
    );
  }

  Widget imageMessage(
      ChatMessage? data, BuildContext context, bool isDarkMode) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onLongPress: () {
        onLongPress(data);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.70, minHeight: 230),
        decoration: BoxDecoration(
          color: data?.senderUser?.userid == SessionManager.userId
              ? ColorRes.colorPink
              : ColorRes.colorPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                _onPress(context, data, ImagePreview(message: data));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: '${ConstRes.itemBaseUrl}${data?.image}',
                  height: 230,
                  width: MediaQuery.of(context).size.width / 1.70,
                  fit: BoxFit.cover,
                  cacheKey: '${ConstRes.itemBaseUrl}${data?.image}',
                  repeat: ImageRepeat.noRepeat,
                  errorWidget: (context, error, stackTrace) {
                    return Image.asset(
                      isDarkMode ? icLogo : icLogoLight,
                      color: ColorRes.colorLight,
                      height: 230,
                      width: MediaQuery.of(context).size.width / 1.70,
                    );
                  },
                ),
              ),
            ),
            data?.msg == null || data!.msg!.isEmpty
                ? SizedBox()
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    child: Text(
                      data.msg ?? '',
                      style: TextStyle(
                          color: isDarkMode
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget videoMessage(
      ChatMessage? data, BuildContext context, bool isDarkMode) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onLongPress: () {
        onLongPress(data);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width / 1.70, minHeight: 230),
        decoration: BoxDecoration(
          color: data?.senderUser?.userid == SessionManager.userId
              ? ColorRes.colorPink
              : ColorRes.colorPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _onPress(context, data, VideoView(message: data));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: CachedNetworkImage(
                      imageUrl: '${ConstRes.itemBaseUrl}${data?.image}',
                      cacheKey: '${ConstRes.itemBaseUrl}${data?.image}',
                      height: 230,
                      width: MediaQuery.of(context).size.width / 1.70,
                      fit: BoxFit.cover,
                      repeat: ImageRepeat.noRepeat,
                      errorWidget: (context, error, stackTrace) {
                        return Image.asset(
                          isDarkMode ? icLogo : icLogoLight,
                          color: ColorRes.colorLight,
                          height: 230,
                          width: MediaQuery.of(context).size.width / 1.70,
                        );
                      },
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _onPress(context, data, VideoView(message: data));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.play_circle_fill_sharp,
                        size: 40, color: ColorRes.white.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
            data?.msg == null || data!.msg!.isEmpty
                ? SizedBox()
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    child: Text(
                      data.msg ?? '',
                      style: TextStyle(
                          color: isDarkMode
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _alertView({required String data, required bool isDarkMode}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isDarkMode ? ColorRes.colorPrimary : ColorRes.greyShade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text('$data', style: const TextStyle(fontSize: 11)),
    );
  }

  void _onPress(BuildContext context, ChatMessage? data, Widget child) {
    if (timeStamp.isEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => child));
    } else {
      onLongPress(data);
    }
  }
}
