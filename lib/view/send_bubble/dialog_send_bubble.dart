import 'dart:ui';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/send_coin_result.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DialogSendBubble extends StatelessWidget {
  final Data? videoData;

  DialogSendBubble(this.videoData);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: AspectRatio(
            aspectRatio: 0.67,
            child: Container(
              decoration: BoxDecoration(
                color:
                    myLoading.isDark ? ColorRes.colorPrimary : ColorRes.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Spacer(flex: 2),
                  Text(
                    '${LKey.send.tr} $appName',
                    style: TextStyle(fontSize: 22),
                  ),
                  Spacer(),
                  Image.asset(myLoading.isDark ? icLogo : icLogoLight,
                      height: 50),
                  Spacer(),
                  Text(
                    LKey.creatorWillBeNotifiedNAboutYourLove.tr,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: ColorRes.colorTextLight, fontSize: 15),
                  ),
                  Spacer(),
                  ItemSendBubble(5, videoData, myLoading),
                  ItemSendBubble(10, videoData, myLoading),
                  ItemSendBubble(15, videoData, myLoading),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        LKey.cancel.tr,
                        style: TextStyle(
                            fontFamily: FontRes.fNSfUiMedium,
                            color: ColorRes.colorTextLight,
                            fontSize: 18),
                      )),
                  Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ItemSendBubble extends StatelessWidget {
  final int bubblesCount;
  final Data? videoData;
  final MyLoading myLoading;
  final SessionManager sessionManager = new SessionManager();

  ItemSendBubble(this.bubblesCount, this.videoData, this.myLoading);

  @override
  Widget build(BuildContext context) {
    final user = myLoading.getUser;
    initPref();
    return GestureDetector(
      onTap: () {
        if ((user?.data?.myWallet ?? 0) > bubblesCount) {
          CommonUI.showLoader(context);
          ApiService()
              .sendCoin(bubblesCount.toString(), videoData!.userId.toString())
              .then(
            (value) {
              Navigator.pop(context);
              Navigator.pop(context);
              myLoading.setUser(sessionManager.getUser());
              showDialog(
                  context: context,
                  builder: (context) => SendCoinsResult(value.status == 200));
            },
          );
        } else {
          CommonUI.showToast(msg: LKey.insufficientBalance.tr);
        }
      },
      child: FittedBox(
        child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width / 2,
          margin: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: myLoading.isDark
                ? ColorRes.colorPrimaryDark
                : ColorRes.greyShade100,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  image: AssetImage(myLoading.isDark ? icLogo : icLogoLight),
                  width: 40,
                  height: 40),
              SizedBox(width: 15),
              Text(
                '$bubblesCount $appName',
                style: TextStyle(fontSize: 16, color: ColorRes.colorTextLight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initPref() async {
    await sessionManager.initPref();
  }
}
