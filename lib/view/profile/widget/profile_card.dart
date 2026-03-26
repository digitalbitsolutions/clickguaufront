import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/followers/follower_screen.dart';
import 'package:bubbly/view/profile/widget/follow_unfollow_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';

import '../profile_screen.dart';

class ProfileCard extends StatelessWidget {
  final UserData? userData;
  final MyLoading myLoading;
  final bool isMyProfile;
  final bool isLogin;
  final bool isBlock;
  final VoidCallback onChatIconClick;
  final Function(bool) onFollowUnFollowClick;
  final VoidCallback onEditProfileClick;

  const ProfileCard(
      {Key? key,
      required this.userData,
      required this.myLoading,
      required this.isMyProfile,
      required this.isLogin,
      required this.isBlock,
      required this.onChatIconClick,
      required this.onFollowUnFollowClick,
      required this.onEditProfileClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return userData == null
        ? LoaderDialog()
        : Column(
            children: [
              SizedBox(height: 60),
              InkWell(
                onTap: () {
                  myLoading.setIsBigProfile(true);
                },
                child: Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(border: Border.all(color: ColorRes.colorTextLight, width: 0.5), shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.network(
                      '${ConstRes.itemBaseUrl}${userData?.userProfile}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ImagePlaceHolder(heightWeight: 110, name: userData?.fullName, fontSize: 110 / 3);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              userData?.profileCategoryName == null || userData!.profileCategoryName!.isEmpty
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(color: myLoading.isDark ? ColorRes.white : ColorRes.colorPrimaryDark, borderRadius: BorderRadius.all(Radius.circular(3))),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                      child: Text(
                        userData?.profileCategoryName ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontRes.fNSfUiBold,
                          color: myLoading.isDark ? ColorRes.colorPrimaryDark : ColorRes.white,
                        ),
                      ),
                    ),
              Text(userData?.fullName ?? AppRes.emptyName, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 20, fontFamily: FontRes.fNSfUiSemiBold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${AppRes.atSign}${userData?.userName ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: ColorRes.colorTextLight,
                      fontFamily: FontRes.fNSfUiMedium,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(width: 5),
                  userData?.isVerify == 1
                      ? Image.asset(
                          icVerify,
                          height: 15,
                          width: 15,
                        )
                      : SizedBox()
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    url: userData?.fbUrl,
                    icon: icFaceBook,
                    myLoading: myLoading,
                  ),
                  SocialButton(
                    url: userData?.instaUrl,
                    icon: icInstagram,
                    myLoading: myLoading,
                  ),
                  SocialButton(
                    url: userData?.youtubeUrl,
                    icon: icYouTube,
                    myLoading: myLoading,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 10),
                child: Text(userData?.bio ?? '', maxLines: 3, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: TextStyle(color: ColorRes.colorTextLight, fontSize: 15)),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(alignment: Alignment.centerLeft, child: VerticalTilesCustom(onTap: () {}, title: LKey.likes.tr, count: userData?.myPostLikes)),
                    VerticalTilesCustom(
                      onTap: () {
                        myLoading.setFollowerPageIndex(0);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FollowerScreen(userData)));
                      },
                      title: LKey.followers.tr,
                      count: userData?.followersCount,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: VerticalTilesCustom(
                        onTap: () {
                          myLoading.setFollowerPageIndex(1);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FollowerScreen(userData)),
                          );
                        },
                        title: LKey.following.tr,
                        count: userData?.followingCount,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !isMyProfile
                      ? FollowUnFollowButton(data: userData, followClick: onFollowUnFollowClick, isLogin: isLogin, isDarkMode: myLoading.isDark)
                      : TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(myLoading.isDark ? ColorRes.white : ColorRes.colorPrimaryDark)),
                          onPressed: onEditProfileClick,
                          child: Text(
                            LKey.editProfile.tr,
                            style: TextStyle(color: myLoading.isDark ? ColorRes.colorPrimaryDark : ColorRes.white),
                          ),
                        ),
                  Visibility(
                    visible: !isMyProfile,
                    child: SizedBox(width: 15),
                  ),
                  Visibility(
                    visible: userData?.isFollowingEachOther == 1,
                    child: Visibility(
                      visible: !isBlock,
                      child: Visibility(
                        visible: !isMyProfile,
                        child: InkWell(
                          onTap: onChatIconClick,
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(color: myLoading.isDark ? ColorRes.colorPrimary : ColorRes.greyShade100, borderRadius: BorderRadius.circular(5), boxShadow: []),
                            padding: EdgeInsets.all(8),
                            child: Image.asset(chatIcon, color: ColorRes.colorTextLight),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
  }
}

class VerticalTilesCustom extends StatelessWidget {
  final VoidCallback onTap;
  final int? count;
  final String title;

  const VerticalTilesCustom({Key? key, required this.onTap, required this.count, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            NumberFormat.compact().format(count ?? 0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorRes.colorTextLight,
              fontSize: 17,
              fontFamily: FontRes.fNSfUiBold,
            ),
          ),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: ColorRes.colorTextLight,
              fontFamily: FontRes.fNSfUiMedium,
            ),
          ),
        ],
      ),
    );
  }
}
