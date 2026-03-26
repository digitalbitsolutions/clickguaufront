import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/search/search_user_screen.dart';
import 'package:bubbly/view/search/search_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int pageIndex = 0;
  TextEditingController searchController = TextEditingController();

  Function(String)? onSearching;

  void searchText(Function(String) value) {
    onSearching = value;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 15),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left, size: 35),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Container(
                        height: 45,
                        margin: EdgeInsets.only(right: 15),
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 5),
                        decoration: BoxDecoration(
                          color: myLoading.isDark
                              ? ColorRes.colorPrimary
                              : ColorRes.greyShade100,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: LKey.search.tr,
                              hintStyle: TextStyle(fontSize: 15)),
                          onChanged: (value) {
                            onSearching?.call(searchController.text);
                            myLoading.setSearchText(value);
                          },
                          style: TextStyle(fontSize: 15),
                          cursorColor: ColorRes.colorTextLight,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          searchController = TextEditingController();
                          onSearching?.call(searchController.text);
                          _pageController.animateToPage(0,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.linear);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: myLoading.isDark
                                ? ColorRes.colorPrimary
                                : ColorRes.greyShade100,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                            child: Text(
                              LKey.videos.tr,
                              style: TextStyle(
                                color: pageIndex == 0
                                    ? ColorRes.colorTheme
                                    : ColorRes.colorTextLight,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          searchController = TextEditingController();
                          onSearching?.call(searchController.text);
                          _pageController.animateToPage(1,
                              duration: Duration(milliseconds: 250),
                              curve: Curves.linear);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: myLoading.isDark
                                ? ColorRes.colorPrimary
                                : ColorRes.greyShade100,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Center(
                            child: Text(
                              LKey.users.tr,
                              style: TextStyle(
                                  color: pageIndex == 1
                                      ? ColorRes.colorTheme
                                      : ColorRes.colorTextLight),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 5),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return index == 0
                          ? SearchVideoScreen(
                              onCallback: searchText,
                            )
                          : SearchUserScreen(
                              onCallback: searchText,
                            );
                    },
                    onPageChanged: (value) {
                      pageIndex = value;
                      myLoading.setSearchPageIndex(value);
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
