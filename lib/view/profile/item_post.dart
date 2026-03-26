import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/view/video/video_list_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemPost extends StatelessWidget {
  final Data? data;
  final List<Data> list;
  final VoidCallback? onTap;
  final int? type;
  final String? userId;
  final String? soundId;

  ItemPost(
      {required this.data,
      this.onTap,
      required this.list,
      this.type,
      this.userId,
      this.soundId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoListScreen(
                list: list,
                index: list.indexOf(data!),
                type: type,
                userId: userId,
                soundId: soundId),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: CachedNetworkImage(
                imageUrl: ConstRes.itemBaseUrl + data!.postImage!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.grey,
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.play_arrow_rounded, color: ColorRes.white, size: 20),
                Text(
                  NumberFormat.compact().format(data?.postViewCount ?? 0),
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorRes.white,
                      fontFamily: FontRes.fNSfUiSemiBold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
