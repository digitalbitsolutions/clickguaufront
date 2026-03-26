import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/sound/sound.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/view/music/widget/music_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemDiscover extends StatelessWidget {
  final SoundData soundData;
  final Function onMoreClick;
  final Function? onPlayClick;

  ItemDiscover(this.soundData, this.onMoreClick, this.onPlayClick);

  @override
  Widget build(BuildContext context) {
    return soundData.soundList == null || soundData.soundList!.isEmpty
        ? SizedBox()
        : Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        soundData.soundCategoryName ?? '',
                        style: TextStyle(
                            color: ColorRes.colorTheme,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: FontRes.fNSfUiSemiBold,
                            fontSize: 16),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        onMoreClick.call(soundData.soundList);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            LKey.more.tr,
                            style: TextStyle(
                              color: ColorRes.colorTextLight,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Image(
                            width: 20,
                            height: 20,
                            image: AssetImage(icMenu),
                            color: ColorRes.colorTheme,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: soundData.soundList?.length,
                itemBuilder: (context, index) {
                  return MusicCard(
                      soundList: soundData.soundList![index],
                      onItemClick: (soundUrl) {
                        onPlayClick!(soundUrl);
                      },
                      type: 1);
                },
              )
            ],
          );
  }
}
