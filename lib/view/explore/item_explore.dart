import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/explore/explore_hash_tag.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/hashtag/videos_by_hashtag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemExplore extends StatefulWidget {
  final ExploreData exploreData;
  final MyLoading myLoading;

  ItemExplore({required this.exploreData, required this.myLoading});

  @override
  _ItemExploreState createState() => _ItemExploreState();
}

class _ItemExploreState extends State<ItemExplore> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return VideosByHashTagScreen(widget.exploreData.hashTagName);
        }));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [ColorRes.colorTheme, ColorRes.colorPink],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Text(
                        AppRes.hashTag,
                        style: TextStyle(
                            fontSize: 25,
                            fontFamily: FontRes.fNSfUiHeavy,
                            color: ColorRes.white),
                      ),
                    ),
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
                        '${AppRes.hashTag}${widget.exploreData.hashTagName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontFamily: FontRes.fNSfUiBold,
                        ),
                      ),
                      Text(
                        '${widget.exploreData.hashTagVideosCount} ${LKey.videos.tr}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            color: ColorRes.colorTextLight,
                            fontFamily: FontRes.fNSfUiLight),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VideosByHashTagScreen(widget.exploreData.hashTagName),
                    ),
                  ),
                  child: Text(
                    LKey.viewAll.tr,
                    style: TextStyle(
                      fontSize: 13,
                      color: ColorRes.colorTextLight,
                      fontFamily: FontRes.fNSfUiLight,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            AspectRatio(
              aspectRatio: 1 / 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: ColorRes.colorPrimary,
                  child: Image(
                    height: 165,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: NetworkImage(ConstRes.itemBaseUrl +
                        widget.exploreData.hashTagProfile!),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
