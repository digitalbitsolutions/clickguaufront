import 'dart:ui';

import 'package:bubbly/custom_view/banner_ads_widget.dart';
import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/live_stream/live_stream.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/live_stream/model/live_stream_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class LiveStreamScreen extends StatelessWidget {
  const LiveStreamScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LiveStreamScreenViewModel>.reactive(
      onViewModelReady: (model) {
        return model.init();
      },
      viewModelBuilder: () => LiveStreamScreenViewModel(),
      builder: (context, model, child) {
        return Consumer(builder: (context, MyLoading myLoading, child) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.only(top: 10, bottom: 2),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  ColorRes.colorPink,
                                  ColorRes.colorTheme,
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: ColorRes.white,
                              size: 18,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            text: '$appName ',
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: FontRes.fNSfUiBold,
                                color: !myLoading.isDark
                                    ? ColorRes.colorPrimary
                                    : ColorRes.greyShade100),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${LKey.live.tr.toUpperCase()}',
                                style: TextStyle(
                                    fontFamily: FontRes.fNSfUiMedium,
                                    color: ColorRes.colorPink,
                                    fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            if ((model.registrationUser?.data?.followersCount ??
                                    0) >=
                                (model.settingData?.minFansForLive ?? 0)) {
                              model.goLiveTap(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(AppRes.minimumFansForLive(
                                        model.settingData?.minFansForLive ??
                                            0))),
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    ColorRes.colorPink,
                                    ColorRes.colorTheme,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: [
                                Image.asset(
                                  goLive,
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  LKey.goLive.tr,
                                  style: TextStyle(
                                      fontFamily: FontRes.fNSfUiSemiBold,
                                      color: ColorRes.white),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  CustomGridView(model: model),
                  SizedBox(height: 10),
                  BannerAdsWidget()
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

class CustomGridView extends StatelessWidget {
  final LiveStreamScreenViewModel model;

  const CustomGridView({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: model.liveUsers.isEmpty
          ? Center(
              child: Text(
                LKey.noUserLive.tr,
                style:
                    TextStyle(fontSize: 18, fontFamily: FontRes.fNSfUiSemiBold),
              ),
            )
          : Container(
              margin: EdgeInsets.all(6),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5),
                  itemCount: model.liveUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return gridTile(
                        context: context, data: model.liveUsers[index]);
                  }),
            ),
    );
  }

  Widget gridTile(
      {required LiveStreamUser data, required BuildContext context}) {
    return GestureDetector(
      onTap: () => model.onImageTap(context, data),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                '${ConstRes.itemBaseUrl}${data.userImage}',
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return ImagePlaceHolder(
                    fontSize: 100,
                    heightWeight: double.infinity,
                    name: data.fullName ?? '',
                  );
                },
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: double.infinity,
                color: ColorRes.colorPrimary.withOpacity(0.6),
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${data.fullName ?? ''} ",
                          style: const TextStyle(
                            color: ColorRes.white,
                            fontSize: 15,
                          ),
                        ),
                        Image.asset(
                          icVerify,
                          height: 16,
                          width: 16,
                        ),
                      ],
                    ),
                    Text(
                      NumberFormat.compact(locale: 'en')
                              .format(data.followers ?? 0) +
                          ' ${LKey.followers.tr}',
                      style: const TextStyle(
                        color: ColorRes.white,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          feEye,
                          width: 20,
                          height: 15,
                          color: ColorRes.white,
                        ),
                        const SizedBox(width: 3.5),
                        Text(
                          NumberFormat.compact(locale: 'en')
                              .format(data.watchingCount ?? 0),
                          style: const TextStyle(
                            color: ColorRes.white,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
