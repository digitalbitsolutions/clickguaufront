import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/followers/item_followers_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class FollowerScreen extends StatelessWidget {
  final UserData? userData;

  FollowerScreen(this.userData);

  @override
  Widget build(BuildContext context) {
    PageController? _pageController = PageController(
        initialPage: Provider.of<MyLoading>(context, listen: false)
            .getFollowerPageIndex);
    return Scaffold(
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Container(
              height: 55,
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 35,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      constraints: BoxConstraints(minWidth: 110),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(500),
                            child: Image.network(
                              ConstRes.itemBaseUrl + userData!.userProfile!,
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                              errorBuilder: (context, error, stackTrace) {
                                return ImagePlaceHolder(
                                  name: userData?.fullName,
                                  heightWeight: 25,
                                  fontSize: 20,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '@${userData!.userName}',
                            style: TextStyle(
                                fontSize: 20, fontFamily: FontRes.fNSfUiBold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 0,
            color: ColorRes.colorTextLight,
            margin: EdgeInsets.only(bottom: 5),
          ),
          Consumer<MyLoading>(
            builder: (BuildContext context, value, Widget? child) {
              return Row(
                children: [
                  SizedBox(width: 20),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pageController.animateToPage(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: ColorRes.colorPrimary,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            '${userData!.followersCount} ${LKey.followers.tr}',
                            style: TextStyle(
                              color: value.getFollowerPageIndex == 0
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
                        _pageController.animateToPage(1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.linear);
                      },
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: ColorRes.colorPrimary,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                          child: Text(
                            '${userData!.followingCount} ${LKey.following.tr}',
                            style: TextStyle(
                              color: value.getFollowerPageIndex == 1
                                  ? ColorRes.colorTheme
                                  : ColorRes.colorTextLight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              );
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: BouncingScrollPhysics(),
              children: [
                ItemFollowersPage(userData?.userId, 0),
                ItemFollowersPage(userData?.userId, 1),
              ],
              onPageChanged: (value) {
                Provider.of<MyLoading>(context, listen: false)
                    .setFollowerPageIndex(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
