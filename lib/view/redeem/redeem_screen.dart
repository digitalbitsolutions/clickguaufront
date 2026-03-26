import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/modal/wallet/my_wallet.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/common_fun.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RedeemScreen extends StatefulWidget {
  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  MyWalletData? _myWalletData;
  String noOfRedeemCoin = '';
  String selectMethod = 'Paypal';
  String account = '';
  InterstitialAd? interstitialAd;
  SessionManager sessionManager = SessionManager();
  SettingData? settingData;

  void _ads() {
    CommonFun.interstitialAd((ad) {
      interstitialAd = ad;
    });
  }

  @override
  void initState() {
    prefData();
    getMyWalletData();
    _ads();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(
      builder: (context, myLoading, child) => Scaffold(
        body: Column(
          children: [
            AppBarCustom(title: LKey.requestRedeem.tr),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120 + 30,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Center(
                              child: Container(
                                height: 120,
                                width: 120,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: myLoading.isDark
                                      ? ColorRes.colorPrimaryDark
                                      : ColorRes.greyShade100,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          ColorRes.colorPink.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  NumberFormat.compact(
                                    locale: 'en',
                                  ).format(_myWalletData?.myWallet ?? 0),
                                  style: TextStyle(
                                    fontFamily: FontRes.fNSfUiBold,
                                    fontSize: 28,
                                  ),
                                ),
                              ),
                            ),
                            FittedBox(
                              child: Container(
                                height: 35,
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                  gradient: LinearGradient(
                                    colors: [
                                      ColorRes.colorTheme,
                                      ColorRes.colorPink,
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$appName ${LKey.youHave.tr}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: FontRes.fNSfUiMedium,
                                      color: ColorRes.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: Text(
                          AppRes.redeemTitle((settingData?.coinValue ?? 0.0)
                              .toStringAsFixed(2)),
                          style: TextStyle(
                              color: ColorRes.colorTextLight, fontSize: 12),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        LKey.selectMethod.tr,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                        ),
                        child: SelectMethodDropdown((value) {
                          selectMethod = value;
                        }, myLoading),
                      ),
                      Text(
                        LKey.account.tr,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                        ),
                        child: TextField(
                          onChanged: (value) => account = value,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: LKey.mailMobile.tr,
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
                      InkWell(
                        onTap: () {
                          if (selectMethod.isEmpty) {
                            CommonUI.showToast(
                                msg: LKey.pleaseSelectPaymentMethod.tr);
                          } else if (account.isEmpty) {
                            CommonUI.showToast(msg: LKey.pleaseEnterAccount.tr);
                          } else {
                            double amount = ((_myWalletData?.myWallet ?? 0) *
                                    (settingData?.coinValue ?? 0)) /
                                1000;
                            CommonUI.showLoader(context);
                            ApiService()
                                .redeemRequest(amount.toString(), selectMethod,
                                    account, noOfRedeemCoin)
                                .then((value) {
                              if (value.status == 200) {
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
                        child: Center(
                          child: FittedBox(
                            child: Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                gradient: LinearGradient(
                                  colors: [
                                    ColorRes.colorTheme,
                                    ColorRes.colorPink,
                                  ],
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                LKey.redeem.tr.toUpperCase(),
                                style: TextStyle(
                                    fontFamily: FontRes.fNSfUiMedium,
                                    letterSpacing: 1,
                                    color: ColorRes.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Text(
                          LKey.redeemRequestsAreProcessedWithIn10DaysNAndBePrepared
                              .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: ColorRes.colorTextLight),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewScreen(3),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            LKey.policyCenter.tr,
                            style: TextStyle(
                              color: ColorRes.colorTheme,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMyWalletData() {
    ApiService().getMyWalletCoin().then((value) {
      _myWalletData = value.data;
      setState(() {});
    });
  }

  void prefData() async {
    await sessionManager.initPref();
    settingData = sessionManager.getSetting()?.data;
    setState(() {});
  }
}

class SelectMethodDropdown extends StatefulWidget {
  final Function function;
  final MyLoading myLoading;

  const SelectMethodDropdown(this.function, this.myLoading);

  @override
  _SelectMethodDropdownState createState() => _SelectMethodDropdownState();
}

class _SelectMethodDropdownState extends State<SelectMethodDropdown> {
  String? currentValue = 'Paypal';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: currentValue,
      underline: Container(),
      isExpanded: true,
      elevation: 16,
      style: TextStyle(color: ColorRes.colorTextLight),
      dropdownColor: widget.myLoading.isDark
          ? ColorRes.colorPrimary
          : ColorRes.greyShade100,
      onChanged: (String? newValue) {
        currentValue = newValue;
        widget.function(currentValue);
        setState(() {});
      },
      iconEnabledColor:
          widget.myLoading.isDark ? ColorRes.white : ColorRes.colorPrimaryDark,
      items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(fontFamily: FontRes.fNSfUiMedium),
          ),
        );
      }).toList(),
    );
  }
}
