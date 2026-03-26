import 'package:bubbly/modal/chat/chat.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatelessWidget {
  final ChatMessage? message;

  const ImagePreview({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            PhotoView(
              imageProvider: NetworkImage(
                '${ConstRes.itemBaseUrl}${message?.image}',
              ),
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
            topBarArea(context)
          ],
        ),
      ),
    );
  }

  Widget topBarArea(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.fromLTRB(21, 18, 23, 18),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Icon(Icons.chevron_left_rounded,
                color: ColorRes.white, size: 30),
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Hero(
                    tag: KeyRes.userName,
                    child: Text(
                      message?.senderUser?.userid == SessionManager.userId
                          ? 'You'
                          : '${message?.senderUser?.userFullName} ',
                      style: const TextStyle(
                        color: ColorRes.white,
                        fontSize: 16,
                        fontFamily: FontRes.fNSfUiSemiBold,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat(
                  '${"dd MMM yyyy"}, ${"hh:mm a"}',
                ).format(DateTime.fromMillisecondsSinceEpoch(
                    message!.time!.toInt())),
                style: const TextStyle(color: ColorRes.white, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
