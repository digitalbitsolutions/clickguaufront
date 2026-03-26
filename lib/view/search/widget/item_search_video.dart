import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/video/video_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemSearchVideo extends StatelessWidget {
  final Data? videoData;
  final List<Data> postList;
  final int? type;
  final String? hashTag;
  final String? keyWord;

  ItemSearchVideo({
    this.videoData,
    required this.postList,
    this.type,
    this.hashTag,
    this.keyWord,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoListScreen(
              list: postList,
              index: postList.indexOf(videoData!),
              type: type,
              hashTag: hashTag,
              keyWord: keyWord,
            ),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: ColorRes.colorPrimaryDark,
          ),
          margin: EdgeInsets.only(top: 10, right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: ColorRes.colorPrimary,
                  child: Image.network(
                    ConstRes.itemBaseUrl + videoData!.postImage!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container();
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    icImageShadow,
                    color: Colors.black,
                    height: 350,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    icImageShadow,
                    color: Colors.black,
                    height: 350,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '@${videoData?.userName ?? ' '}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: FontRes.fNSfUiSemiBold,
                              fontSize: 15,
                              color: ColorRes.white,
                              letterSpacing: 0.5),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            videoData?.postDescription ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: FontRes.fNSfUiLight,
                              color: ColorRes.white,
                              letterSpacing: 0.6,
                              fontSize: 13,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: ColorRes.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              NumberFormat.compact(locale: 'en')
                                  .format(videoData?.postLikesCount ?? 0),
                              style: TextStyle(color: ColorRes.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
