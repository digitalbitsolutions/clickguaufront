import 'dart:ui';

import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class AgreementHomeDialog extends StatelessWidget {
  const AgreementHomeDialog({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => PopScope(
        canPop: false,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 55),
            backgroundColor: Colors.transparent,
            child: AspectRatio(
              aspectRatio: 1 / 1.2,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorRes.colorPrimaryDark,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      LKey.pleaseAccept.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: FontRes.fNSfUiSemiBold,
                        decoration: TextDecoration.none,
                        color: ColorRes.white,
                      ),
                    ),
                    Spacer(),
                    Image(
                      image:
                          AssetImage(myLoading.isDark ? icLogo : icLogoLight),
                      height: 70,
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        LKey.pleaseCheckThesePrivacyEtc.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: FontRes.fNSfUiLight,
                          decoration: TextDecoration.none,
                          color: ColorRes.colorTextLight,
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(2),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              LKey.termsConditions.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontRes.fNSfUiLight,
                                decoration: TextDecoration.none,
                                color: ColorRes.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 2,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          color: ColorRes.white.withOpacity(0.5),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(3),
                                ));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              LKey.privacyPolicy.tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: FontRes.fNSfUiLight,
                                decoration: TextDecoration.none,
                                color: ColorRes.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        myLoading.setIsHomeDialogOpen(false);
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: ColorRes.colorPrimary,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            LKey.accept.tr,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontRes.fNSfUiLight,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
