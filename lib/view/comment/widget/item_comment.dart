import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/modal/comment/comment.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';

class ItemComment extends StatelessWidget {
  final CommentData commentData;
  final VoidCallback onRemoveClick;

  ItemComment({required this.commentData, required this.onRemoveClick});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.network(
                  ConstRes.itemBaseUrl + commentData.userProfile!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ImagePlaceHolder(
                      name: commentData.fullName,
                      heightWeight: 50,
                      fontSize: 30,
                    );
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentData.fullName ?? '',
                      style: TextStyle(
                        fontFamily: FontRes.fNSfUiMedium,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      commentData.comment!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorRes.colorTextLight,
                        fontFamily: FontRes.fNSfUiRegular,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: commentData.userId == SessionManager.userId,
                child: IconButton(
                  icon: Icon(Icons.delete, size: 20),
                  color: ColorRes.colorTextLight,
                  onPressed: onRemoveClick,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: ColorRes.colorTextLight,
          thickness: 0.2,
        )
      ],
    );
  }
}
