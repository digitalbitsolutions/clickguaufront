import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatefulWidget {
  final int reportType;
  final String? id;

  ReportScreen(this.reportType, this.id);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? currentValue;
  String reason = '';
  String description = '';
  String contactInfo = '';

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Container(
        margin: EdgeInsets.only(top: AppBar().preferredSize.height),
        decoration: BoxDecoration(
          color: myLoading.isDark ? ColorRes.colorPrimaryDark : ColorRes.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(AppRes.whatReport(widget.reportType),
                      style: TextStyle(fontSize: 18)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 0.2, color: ColorRes.colorTextLight),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        LKey.selectReason.tr,
                        style: TextStyle(
                            fontSize: 15, fontFamily: FontRes.fNSfUiMedium),
                      ),
                      Container(
                        width: double.infinity,
                        height: 55,
                        margin: EdgeInsets.only(top: 5, bottom: 20),
                        padding: EdgeInsets.only(right: 15, left: 15, top: 2),
                        decoration: BoxDecoration(
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: DropdownButton<String>(
                          value: currentValue,
                          underline: Container(),
                          isExpanded: true,
                          elevation: 16,
                          style: TextStyle(color: ColorRes.colorTextLight),
                          dropdownColor: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                          borderRadius: BorderRadius.circular(10),
                          onChanged: (String? newValue) {
                            currentValue = newValue;
                            setState(() {});
                          },
                          items: reportReasons
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style:
                                    TextStyle(fontFamily: FontRes.fNSfUiMedium),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Text(
                        LKey.howItHurtsYou.tr,
                        style: TextStyle(
                          fontFamily: FontRes.fNSfUiMedium,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 150,
                        margin: EdgeInsets.only(top: 5, bottom: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                        decoration: BoxDecoration(
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            hintText: LKey.explainBriefly.tr,
                            hintStyle: TextStyle(
                                color: ColorRes.colorTextLight,
                                fontFamily: FontRes.fNSfUiLight),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontFamily: FontRes.fNSfUiMedium),
                          onChanged: (value) {
                            description = value;
                          },
                          cursorColor: ColorRes.colorTextLight,
                          maxLines: 7,
                          scrollPhysics: BouncingScrollPhysics(),
                        ),
                      ),
                      Text(
                        LKey.contactDetailMailOrMobile.tr,
                        style: TextStyle(
                            fontSize: 15, fontFamily: FontRes.fNSfUiMedium),
                      ),
                      Container(
                        width: double.infinity,
                        height: 55,
                        margin: EdgeInsets.only(top: 5, bottom: 20),
                        padding: EdgeInsets.only(right: 15, left: 15, top: 2),
                        decoration: BoxDecoration(
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            hintText: LKey.mailOrPhone.tr,
                            hintStyle: TextStyle(
                                color: ColorRes.colorTextLight,
                                fontFamily: FontRes.fNSfUiLight),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            contactInfo = value;
                          },
                          style: TextStyle(
                              color: ColorRes.white,
                              fontFamily: FontRes.fNSfUiMedium),
                          maxLines: 1,
                          scrollPhysics: BouncingScrollPhysics(),
                          cursorColor: ColorRes.colorTextLight,
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 15),
                          width: 175,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: () {
                              if (currentValue == null ||
                                  currentValue!.isEmpty) {
                                CommonUI.showToast(
                                    msg: LKey.pleaseSelectReason.tr);
                                return;
                              }
                              if (description.isEmpty) {
                                CommonUI.showToast(
                                    msg: LKey.pleaseEnterDescription.tr);
                                return;
                              }
                              if (contactInfo.isEmpty) {
                                CommonUI.showToast(
                                    msg: LKey.pleaseEnterContactDetail.tr);
                                return;
                              }
                              CommonUI.showLoader(context);
                              ApiService()
                                  .reportUserOrPost(
                                      reportType:
                                          widget.reportType == 1 ? "2" : "1",
                                      postIdOrUserId: widget.id,
                                      reason: currentValue,
                                      description: description,
                                      contactInfo: contactInfo)
                                  .then((value) {
                                print(value.status);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorRes.colorTheme),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              LKey.submit.tr.toUpperCase(),
                              style: TextStyle(
                                color: ColorRes.white,
                                fontSize: 15,
                                fontFamily: FontRes.fNSfUiMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          LKey.byClickingThisSubmitButtonYouAgreeThatNYouAreTakingAll
                              .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorRes.colorTextLight,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebViewScreen(3)),
                        ),
                        child: Center(
                          child: Text(
                            LKey.policyCenter.tr,
                            textAlign: TextAlign.center,
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
      );
    });
  }
}
