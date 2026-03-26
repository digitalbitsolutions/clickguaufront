import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/home/following_screen.dart';
import 'package:bubbly/view/home/for_u_screen.dart';
import 'package:bubbly/view/home/widget/agreement_home_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SessionManager sessionManager = SessionManager();
  int pageIndex = 1;

  @override
  void initState() {
    _homeAgreementDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) {
        PageController controller =
            PageController(initialPage: 1, keepPage: true);
        return Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                controller: controller,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return index == 0 ? FollowingScreen() : ForYouScreen();
                },
                onPageChanged: (value) {
                  pageIndex = value;
                  myLoading.setIsForYouSelected(value == 1);
                },
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          controller.animateToPage(0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInToLinear);
                        },
                        child: Text(
                          LKey.following.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: FontRes.fNSfUiSemiBold,
                            color: pageIndex == 0
                                ? ColorRes.colorTheme
                                : ColorRes.greyShade100,
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 15),
                          height: 25,
                          width: 2,
                          color: ColorRes.colorTheme),
                      InkWell(
                        onTap: () {
                          controller.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInToLinear);
                        },
                        child: Text(
                          LKey.forYou.tr,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: FontRes.fNSfUiSemiBold,
                              color: pageIndex == 1
                                  ? ColorRes.colorTheme
                                  : ColorRes.colorTextLight),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _homeAgreementDialog() async {
    await Future.delayed(Duration.zero);
    Provider.of<MyLoading>(context, listen: false).getIsHomeDialogOpen
        ? showDialog(
            context: context,
            builder: (context) {
              return AgreementHomeDialog();
            },
            barrierDismissible: true)
        : SizedBox();
  }
}
