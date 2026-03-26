import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/banner_ads_widget.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/explore/explore_hash_tag.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/explore/item_explore.dart';
import 'package:bubbly/view/live_stream/screen/live_stream_screen.dart';
import 'package:bubbly/view/login/login_sheet.dart';
import 'package:bubbly/view/qrcode/scan_qr_code_screen.dart';
import 'package:bubbly/view/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int start = 0;

  ScrollController _scrollController = ScrollController();
  SessionManager sessionManager = SessionManager();
  List<ExploreData> exploreList = [];
  bool isLoading = true;
  bool isHaseMore = true;
  bool isFirstTime = true;

  bool isLogin = false;

  @override
  void initState() {
    prefData();
    callApiExploreHashTag();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (!isLoading) {
          callApiExploreHashTag();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        height: 45,
                        decoration: BoxDecoration(
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LKey.search.tr,
                              style: TextStyle(
                                color: ColorRes.colorTextLight,
                                fontSize: 15,
                              ),
                            ),
                            Image(
                              height: 20,
                              image: AssetImage(icSearch),
                              color: ColorRes.colorTextLight,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (SessionManager.userId == -1 || !isLogin) {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return LoginSheet();
                          },
                        ).then(
                          (value) => myLoading.setSelectedItem(1),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LiveStreamScreen(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              ColorRes.colorPink,
                              ColorRes.colorTheme,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          Image.asset(
                            liveRound,
                            height: 20,
                            width: 20,
                            color: ColorRes.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            LKey.lives.tr.toUpperCase(),
                            style: TextStyle(
                                fontSize: 11,
                                color: ColorRes.white,
                                fontFamily: FontRes.fNSfUiSemiBold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScanQrCodeScreen())),
                    child: Image(
                      height: 20,
                      image: AssetImage(icQrCode),
                      color: ColorRes.colorTextLight,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: isFirstTime == true
                    ? LoaderDialog()
                    : exploreList.isEmpty
                        ? DataNotFound()
                        : ListView(
                            padding: EdgeInsets.only(top: 15),
                            shrinkWrap: true,
                            controller: _scrollController,
                            physics: BouncingScrollPhysics(),
                            children: List.generate(
                              exploreList.length,
                              (index) => ItemExplore(
                                  exploreData: exploreList[index],
                                  myLoading: myLoading),
                            ),
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

  void callApiExploreHashTag() {
    if (!isHaseMore) {
      return;
    }
    isLoading = true;
    ApiService()
        .getExploreHashTag(
            exploreList.length.toString(), paginationLimit.toString())
        .then((value) {
      if (isFirstTime) {
        isFirstTime = false;
      }
      if ((value.data?.length ?? 0) < paginationLimit) {
        isHaseMore = false;
      }
      exploreList.addAll(value.data ?? []);
      isLoading = false;
      setState(() {});
    });
  }

  void prefData() async {
    await sessionManager.initPref();
    isLogin = sessionManager.getBool(KeyRes.login) ?? false;
    setState(() {});
  }
}
