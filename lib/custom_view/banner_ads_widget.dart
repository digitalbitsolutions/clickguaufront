import 'dart:io';

import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdsWidget extends StatefulWidget {
  const BannerAdsWidget({Key? key}) : super(key: key);

  @override
  State<BannerAdsWidget> createState() => _BannerAdsWidgetState();
}

class _BannerAdsWidgetState extends State<BannerAdsWidget> {
  BannerAd? bannerAd;
  SettingData? settingData;

  @override
  void initState() {
    getBannerAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return bannerAd != null
        ? Container(
            alignment: Alignment.center,
            child: AdWidget(ad: bannerAd!),
            width: bannerAd?.size.width.toDouble(),
            height: bannerAd?.size.height.toDouble(),
          )
        : SizedBox();
  }

  SessionManager sessionManager = SessionManager();

  void getBannerAd() async {
    await sessionManager.initPref();
    settingData = sessionManager.getSetting()?.data;
    BannerAd(
      adUnitId: Platform.isIOS
          ? "${settingData?.admobBannerIos}"
          : "${settingData?.admobBanner}",
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          bannerAd = ad as BannerAd;
          setState(() {});
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }
}
