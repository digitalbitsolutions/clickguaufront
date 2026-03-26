import 'package:bubbly/custom_view/banner_ads_widget.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/notification/widget/chat_list.dart';
import 'package:bubbly/view/notification/widget/notification_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  PageController controller = PageController();

  @override
  void initState() {
    controller = PageController(
        initialPage: Provider.of<MyLoading>(context, listen: false)
            .getNotificationPageIndex,
        keepPage: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(
      builder: (context, myLoading, child) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      myLoading.setNotificationPageIndex(0);
                      controller.animateToPage(0,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.linear);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 15, top: 20, bottom: 15),
                      child: Text(
                        LKey.notifications.tr,
                        style: TextStyle(
                          color: myLoading.isDark
                              ? myLoading.getNotificationPageIndex == 0
                                  ? ColorRes.white
                                  : ColorRes.colorTextLight
                              : myLoading.getNotificationPageIndex == 0
                                  ? ColorRes.colorPrimaryDark
                                  : ColorRes.colorPrimaryDark.withOpacity(0.5),
                          fontFamily: FontRes.fNSfUiBold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 2,
                    color: myLoading.isDark
                        ? ColorRes.white
                        : ColorRes.colorPrimaryDark,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  InkWell(
                    onTap: () {
                      myLoading.setNotificationPageIndex(1);
                      controller.animateToPage(1,
                          duration: Duration(milliseconds: 250),
                          curve: Curves.linear);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      child: Text(
                        LKey.chats.tr,
                        style: TextStyle(
                          color: myLoading.isDark
                              ? myLoading.getNotificationPageIndex == 1
                                  ? ColorRes.white
                                  : ColorRes.colorTextLight
                              : myLoading.getNotificationPageIndex == 1
                                  ? ColorRes.colorPrimaryDark
                                  : ColorRes.colorPrimaryDark.withOpacity(0.5),
                          fontFamily: FontRes.fNSfUiBold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: controller,
                  onPageChanged: (value) =>
                      myLoading.setNotificationPageIndex(value),
                  children: [
                    NotificationList(),
                    ChatList(
                      myLoading: myLoading,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              BannerAdsWidget()
            ],
          ),
        ),
      ),
    );
  }
}
