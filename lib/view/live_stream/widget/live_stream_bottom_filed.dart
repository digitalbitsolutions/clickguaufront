import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/view/live_stream/model/broad_cast_screen_view_model.dart';
import 'package:flutter/material.dart';

class LiveStreamBottomField extends StatelessWidget {
  final BroadCastScreenViewModel model;

  const LiveStreamBottomField({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(fontSize: 15, color: ColorRes.white),
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        controller: model.commentController,
                        focusNode: model.commentFocus,
                        cursorColor: ColorRes.white,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Comment...',
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            hintStyle: TextStyle(
                                color: ColorRes.white.withOpacity(0.70),
                                fontSize: 15)),
                      ),
                    ),
                    InkWell(
                      onTap: model.onComment,
                      child: Container(
                        margin: EdgeInsets.all(3),
                        padding: EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [ColorRes.colorPink, ColorRes.colorTheme],
                          ),
                        ),
                        child: Image.asset(send),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: !model.isHost,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => model.onGiftTap(context),
                child: Container(
                  height: 45,
                  width: 45,
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorRes.colorPink,
                        ColorRes.colorTheme,
                      ],
                    ),
                  ),
                  child: Image.asset(gift),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
