import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/live_stream/live_stream.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/live_stream/model/broad_cast_screen_view_model.dart';
import 'package:bubbly/view/live_stream/widget/blur_tab.dart';
import 'package:bubbly/view/report/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AudienceTopBar extends StatelessWidget {
  final BroadCastScreenViewModel model;
  final LiveStreamUser user;

  const AudienceTopBar({Key? key, required this.model, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BlurTab(
            height: 65,
            radius: 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      model.onUserTap(context);
                    },
                    child: ClipOval(
                      child: Image.network(
                        "${ConstRes.itemBaseUrl}${user.userImage}",
                        fit: BoxFit.cover,
                        height: 45,
                        width: 45,
                        errorBuilder: (context, error, stackTrace) {
                          return ImagePlaceHolder(
                            name: user.fullName,
                            heightWeight: 45,
                            fontSize: 25,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        model.onUserTap(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.fullName ?? '',
                                style: TextStyle(
                                    color: ColorRes.white,
                                    fontFamily: FontRes.fNSfUiMedium),
                              ),
                              Visibility(
                                visible: user.isVerified ?? false,
                                child: Image.asset(
                                  icVerify,
                                  height: 15,
                                  width: 15,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            "${user.followers ?? 0} ${LKey.followers.tr}",
                            style: TextStyle(
                                color: ColorRes.white.withOpacity(0.5),
                                fontFamily: FontRes.fNSfUiMedium),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ReportScreen(2, "${user.userId}"),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    child: Image.asset(
                      icMenu,
                      height: 20,
                      width: 20,
                      color: ColorRes.white,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          BlurTab(
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Image.asset(
                    Provider.of<MyLoading>(context, listen: true).isDark
                        ? icLogo
                        : icLogoLight,
                    height: 20),
                Text(
                  ' LIVE',
                  style: TextStyle(
                      fontFamily: FontRes.fNSfUiSemiBold,
                      fontSize: 16,
                      color: ColorRes.white),
                ),
                Spacer(),
                Text(
                  "${NumberFormat.compact(locale: 'en').format(double.parse('${model.liveStreamUser?.watchingCount ?? '0'}'))} Viewers",
                  style: TextStyle(
                      fontFamily: FontRes.fNSfUiRegular,
                      fontSize: 15,
                      color: ColorRes.white),
                ),
                Spacer(),
                InkWell(
                  onTap: model.audienceExit,
                  child: Row(
                    children: [
                      Image.asset(
                        exit,
                        height: 20,
                        width: 20,
                        color: ColorRes.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Exit",
                        style: TextStyle(
                            fontSize: 15,
                            color: ColorRes.white,
                            fontFamily: FontRes.fNSfUiMedium),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
