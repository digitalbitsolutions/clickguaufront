import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/common_fun.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrScanCodeScreen extends StatefulWidget {
  @override
  State<MyQrScanCodeScreen> createState() => _MyQrScanCodeScreenState();
}

class _MyQrScanCodeScreenState extends State<MyQrScanCodeScreen> {
  InterstitialAd? interstitialAd;
  User? userData;
  final GlobalKey screenshotKey = GlobalKey();

  @override
  void initState() {
    userData = Provider.of<MyLoading>(context, listen: false).getUser;
    setState(() {});
    _initAds();
    super.initState();
  }

  void _initAds() {
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppBarCustom(title: LKey.myCode.tr),
              Flexible(
                child: SingleChildScrollView(
                  child: RepaintBoundary(
                    key: screenshotKey,
                    child: Container(
                      width: double.infinity,
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        color: myLoading.isDark
                            ? ColorRes.colorPrimary
                            : ColorRes.greyShade100,
                        boxShadow: [
                          BoxShadow(
                            color: myLoading.isDark
                                ? Colors.black
                                : Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25, bottom: 15),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: QrImageView(
                                backgroundColor: ColorRes.white,
                                data: SessionManager.userId.toString(),
                                version: QrVersions.auto,
                                size: 200.0,
                              ),
                            ),
                          ),
                          ClipOval(
                            child: Image.network(
                              ConstRes.itemBaseUrl +
                                  '${userData?.data?.userProfile ?? ''}',
                              height: 50,
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return ImagePlaceHolder(
                                  heightWeight: 50,
                                  name: userData?.data?.fullName,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${AppRes.atSign}${userData?.data?.userName ?? ''}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 15),
                            child: Text(
                              userData?.data?.bio ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: ColorRes.colorTextLight,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            LKey.scanToFollowMe.tr,
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorRes.colorIcon,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Image(
                            image: AssetImage(myLoading.isDark
                                ? icLogoHorizontal
                                : icLogoHorizontalLight),
                            height: 60,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => _takeScreenShot(context),
                    child: Column(
                      children: [
                        ClipOval(
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorRes.colorTheme,
                                  ColorRes.colorPink,
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Image(
                                image: AssetImage(icDownload),
                                color: ColorRes.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          LKey.saveCode.tr,
                          style: TextStyle(
                            color: ColorRes.colorTextLight,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: AppBar().preferredSize.height / 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _takeScreenShot(BuildContext context) async {
    CommonUI.showLoader(context);
    RenderRepaintBoundary boundary = screenshotKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 10);
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));
    if (byteData == null) return;
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    convertImageToFile(pngBytes, context).then((value) {
      Navigator.pop(context);
    });
  }

  Future<void> convertImageToFile(Uint8List image, BuildContext context) async {
    if (Platform.isAndroid) {
      final file = File(
          '/storage/emulated/0/Download/${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(image);
    } else {
      var f = await getApplicationDocumentsDirectory();
      print(f);
      final file = File('${f.path}/myqrcode.png');
      await file.writeAsBytes(image);
      BubblyCamera.saveImage(file.path);
    }
    if (interstitialAd != null) {
      await interstitialAd?.show();
    } else {
      Navigator.pop(context);
    }
    _initAds();
    CommonUI.showToast(msg: LKey.fileSavedSuccessfully.tr);
  }
}
