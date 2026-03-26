import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EndUserLicenseAgreement extends StatelessWidget {
  final SessionManager sessionManager;

  const EndUserLicenseAgreement({Key? key, required this.sessionManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => Container(
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height * 1.5,
        decoration: BoxDecoration(
            color: myLoading.isDark ? ColorRes.colorPrimary : ColorRes.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Center(
                    child: Text(
                  LKey.endUserLicenseAgreement.tr,
                  style: TextStyle(fontSize: 16),
                ))),
            Divider(height: 1),
            SizedBox(height: 10),
            Expanded(
                child: WebView(
                    initialUrl: ConstRes.agreementUrl,
                    javascriptMode: JavascriptMode.unrestricted)),
            InkWell(
              onTap: () {
                sessionManager.saveBoolean(KeyRes.isAccepted, true);
                Navigator.pop(context);
              },
              child: Container(
                  alignment: Alignment.center,
                  height: 70,
                  color: myLoading.isDark
                      ? ColorRes.colorPrimary
                      : ColorRes.greyShade100,
                  child: SafeArea(
                      top: false,
                      child: Text(
                        LKey.accept.tr,
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
