import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/common_fun.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String photoWithId = '';
  String photoId = '';
  String idNumber = '';
  String nameOnId = '';
  String fullAddress = '';
  InterstitialAd? interstitialAd;

  var sessionManager = SessionManager();

  @override
  void initState() {
    initPref();
    _ads();
    super.initState();
  }

  void _ads() {
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => Scaffold(
        body: Column(
          children: [
            AppBarCustom(title: LKey.requestVerification.tr),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        LKey.yourPhotoHoldingYourIdCard.tr,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ClipOval(
                        child: Image(
                          height: 125,
                          width: 125,
                          image: (photoWithId.isEmpty
                                  ? AssetImage(icImgHoldingId)
                                  : FileImage(File(photoWithId)))
                              as ImageProvider<Object>,
                          fit: photoWithId.isEmpty
                              ? BoxFit.fitWidth
                              : BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 35,
                        child: TextButton(
                          onPressed: () {
                            ImagePicker()
                                .pickImage(
                                    source: ImageSource.camera,
                                    imageQuality: imageQuality,
                                    maxHeight: maxHeight,
                                    maxWidth: maxWidth)
                                .then((value) {
                              photoWithId = value!.path;
                              setState(() {});
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                myLoading.isDark
                                    ? ColorRes.colorPrimary
                                    : ColorRes.greyShade100),
                          ),
                          child: Text(
                            LKey.capture.tr,
                            style: TextStyle(
                              color: ColorRes.colorIcon,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        LKey.photoOfIdClearPhoto.tr,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Image(
                        image: (photoId.isEmpty
                                ? AssetImage(icBgId)
                                : FileImage(File(photoId)))
                            as ImageProvider<Object>,
                        height: 95,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        width: 150,
                        height: 35,
                        child: TextButton(
                          onPressed: () {
                            ImagePicker()
                                .pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: imageQuality,
                                    maxHeight: maxHeight,
                                    maxWidth: maxWidth)
                                .then((value) {
                              photoId = value!.path;
                              setState(() {});
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                myLoading.isDark
                                    ? ColorRes.colorPrimary
                                    : ColorRes.greyShade100),
                          ),
                          child: Text(
                            LKey.attach.tr,
                            style: TextStyle(
                              color: ColorRes.colorIcon,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          LKey.idNumber.tr,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                        ),
                        child: TextField(
                          onChanged: (value) => idNumber = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LKey.enterIdNumber.tr,
                            hintStyle: TextStyle(
                              color: ColorRes.colorTextLight,
                            ),
                          ),
                          style: TextStyle(
                            color: ColorRes.colorTextLight,
                          ),
                          cursorColor: ColorRes.colorTextLight,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          LKey.nameOnId.tr,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                        ),
                        child: TextField(
                          onChanged: (value) => nameOnId = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LKey.sameAsId.tr,
                            hintStyle: TextStyle(
                              color: ColorRes.colorTextLight,
                            ),
                          ),
                          style: TextStyle(
                            color: ColorRes.colorTextLight,
                          ),
                          cursorColor: ColorRes.colorTextLight,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          LKey.fullAddress.tr,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 115,
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                        ),
                        child: TextField(
                          onChanged: (value) => fullAddress = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LKey.sameAsId.tr,
                            hintStyle: TextStyle(
                              color: ColorRes.colorTextLight,
                            ),
                          ),
                          style: TextStyle(
                            color: ColorRes.colorTextLight,
                          ),
                          cursorColor: ColorRes.colorTextLight,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      InkWell(
                        onTap: () {
                          if (photoWithId.isEmpty) {
                            CommonUI.showToast(msg: LKey.pleaseCaptureImage.tr);
                          } else if (photoId.isEmpty) {
                            CommonUI.showToast(
                                msg: LKey.pleaseAttachYourIdCard.tr);
                          } else if (idNumber.isEmpty) {
                            CommonUI.showToast(
                                msg: LKey.pleaseEnterYourIdNumber.tr);
                          } else if (nameOnId.isEmpty) {
                            CommonUI.showToast(
                                msg: LKey.pleaseEnterYourName.tr);
                          } else if (fullAddress.isEmpty) {
                            CommonUI.showToast(
                                msg: LKey.pleaseEnterYourFullAddress.tr);
                          } else {
                            CommonUI.showLoader(context);
                            ApiService()
                                .verifyRequest(idNumber, nameOnId, fullAddress,
                                    File(photoWithId), File(photoId))
                                .then((value) {
                              if (value.status == 200) {
                                CommonUI.showToast(
                                    msg: LKey
                                        .requestForVerificationSuccessfully.tr);
                                Provider.of<MyLoading>(context, listen: false)
                                    .setUser(sessionManager.getUser());
                                if (interstitialAd != null) {
                                  interstitialAd?.show().then((value) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                } else {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              }
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 175,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            gradient: LinearGradient(
                              colors: [
                                ColorRes.colorTheme,
                                ColorRes.colorPink,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              LKey.submit.tr.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: FontRes.fNSfUiSemiBold,
                                  letterSpacing: 1,
                                  color: ColorRes.white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void initPref() async {
    await sessionManager.initPref();
  }
}
