import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/plan/coin_plans.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';

class DialogCoinsPlan extends StatefulWidget {
  @override
  State<DialogCoinsPlan> createState() => _DialogCoinsPlanState();
}

class _DialogCoinsPlanState extends State<DialogCoinsPlan> {
  List<CoinPlanData> plans = [];
  int coinAmount = 0;
  SessionManager sessionManager = SessionManager();
  SettingData? settingData;

  late StreamSubscription<dynamic> _subscription;
  final Set<String> _productId = <String>{};
  List<ProductDetails> products = [];

  bool isLoading = true;

  @override
  void initState() {
    prefData();
    initInAppPurchase();
    getPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Container(
        height: 450,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorRes.colorTheme, ColorRes.colorPink],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(icStore),
                    color: ColorRes.white,
                    height: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${LKey.shop.tr} $appName',
                    style: TextStyle(
                      fontFamily: FontRes.fNSfUiMedium,
                      color: ColorRes.white,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color:
                    myLoading.isDark ? ColorRes.colorPrimary : ColorRes.white,
                child: isLoading
                    ? LoaderDialog()
                    : products.isEmpty
                        ? DataNotFound()
                        : ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Row(
                                      children: [
                                        Image(
                                            height: 30,
                                            image: AssetImage(myLoading.isDark
                                                ? icLogo
                                                : icLogoLight)),
                                        SizedBox(width: 25),
                                        Expanded(
                                          child: Text(
                                            products[index].title,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            CommonUI.showLoader(context);
                                            makePurchase(products[index]);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    ColorRes.colorTheme),
                                          ),
                                          child: Text(
                                            products[index].price,
                                            style: TextStyle(
                                                fontFamily:
                                                    FontRes.fNSfUiSemiBold,
                                                color: ColorRes.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 0.1,
                                    color: !myLoading.isDark
                                        ? ColorRes.colorPrimary
                                        : ColorRes.white,
                                  ),
                                ],
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void initInAppPurchase() {
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var element in purchaseDetailsList) {
      if (element.status == PurchaseStatus.pending) {
        log('Pending ');
        CommonUI.showLoader(context);
      } else {
        Get.back();
        if (element.status == PurchaseStatus.error) {
          log('Error :: ${element.error?.message}');
          CommonUI.showToast(msg: element.error?.message ?? '');
        } else if (element.status == PurchaseStatus.purchased ||
            element.status == PurchaseStatus.restored) {
          log('Purchase Successfully');

          // Call Api To Add Diamond In Wallet
          CoinPlanData coinPlanData = plans.firstWhere((e) {
            if (Platform.isIOS) {
              return e.appstoreProductId == element.productID;
            } else {
              return e.playstoreProductId == element.productID;
            }
          });
          ApiService().purchaseCoin(coinPlanData.coinAmount ?? 0).then(
            (value) {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }
        if (element.pendingCompletePurchase) {
          await InAppPurchase.instance.completePurchase(element);
        }
      }
    }
  }

  void makePurchase(ProductDetails products) {
    PurchaseParam purchaseParam = PurchaseParam(productDetails: products);
    InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
  }

  void prefData() async {
    await sessionManager.initPref();
    settingData = sessionManager.getSetting()?.data;
    setState(() {});
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void getPlan() {
    isLoading = true;
    ApiService().getCoinPlanList().then((value) async {
      plans = value.data ?? [];
      for (var element in plans) {
        if (Platform.isAndroid) {
          _productId.add(element.playstoreProductId ?? '');
        } else {
          _productId.add(element.appstoreProductId ?? '');
        }
      }
      print(_productId);

      // Fetch Product
      final ProductDetailsResponse response =
          await InAppPurchase.instance.queryProductDetails(_productId);

      products = response.productDetails;

      isLoading = false;
      setState(() {});
    });
  }
}
