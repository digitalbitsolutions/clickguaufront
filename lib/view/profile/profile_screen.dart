import 'dart:async';
import 'dart:ui';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/chat/chat.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/chat_screen/chat_screen.dart';
import 'package:bubbly/view/profile/edit_profile_screen.dart';
import 'package:bubbly/view/profile/profile_video_screen.dart';
import 'package:bubbly/view/profile/widget/profile_card.dart';
import 'package:bubbly/view/profile/widget/tab_bar_view_custom.dart';
import 'package:bubbly/view/profile/widget/top_bar_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final int type;
  final String userId;

  ProfileScreen({required this.type, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(initialPage: 0);

  SessionManager _sessionManager = SessionManager();
  String? userId;
  UserData? userData;
  bool isMyProfile = true;
  bool isBlock = false;
  bool isLogin = false;
  Function? fetchScrollData;
  bool isLoading = true;

  @override
  void initState() {
    prefData();
    if (widget.type == 0) {
      userId = SessionManager.userId.toString();
    } else {
      print('data : ${widget.userId}');
      userId = widget.userId;
    }
    isMyProfile = userId.toString() == SessionManager.userId.toString();

    getUserProfile();
    scrollController.addListener(() {
      if (scrollController.offset >= scrollController.position.maxScrollExtent) {
        Provider.of<MyLoading>(context, listen: false).setScrollProfileVideo(true);
      }
    });
    pageController = PageController(initialPage: 0, keepPage: true);
    super.initState();
  }

  Future<void> prefData() async {
    await _sessionManager.initPref();
    userData = _sessionManager.getUser()?.data;
    isLogin = _sessionManager.getBool(KeyRes.login) ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(
      builder: (context, MyLoading myLoading, child) {
        pageController = PageController(initialPage: myLoading.getProfilePageIndex);
        return Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: isLoading
                    ? LoaderDialog()
                    : NestedScrollView(
                        controller: scrollController,
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              expandedHeight: getTotalHeight(userData != null ? userData : null),
                              floating: false,
                              pinned: true,
                              automaticallyImplyLeading: false,
                              backgroundColor: !myLoading.isDark ? ColorRes.white : ColorRes.colorPrimaryDark,
                              title:
                                  TopBarProfile(isDarkMode: myLoading.isDark, isBlock: isBlock, isMyProfile: isMyProfile, profileType: widget.type, userData: userData, onBlockApiCall: blockApiCall),
                              flexibleSpace: FlexibleSpaceBar(
                                  collapseMode: CollapseMode.parallax,
                                  background: ProfileCard(
                                      userData: userData,
                                      myLoading: myLoading,
                                      isMyProfile: isMyProfile,
                                      isBlock: isBlock,
                                      isLogin: isLogin,
                                      onChatIconClick: onChatIconClick,
                                      onFollowUnFollowClick: onFollowUnFollowClick,
                                      onEditProfileClick: onEditProfileClick)),
                            ),
                            SliverPersistentHeader(
                                delegate: _SliverAppBarDelegate(
                                  consumer: Consumer<MyLoading>(builder: (context, myLoading, child) {
                                    return TabBarViewCustom(
                                      pageController: pageController,
                                      myLoading: myLoading,
                                    );
                                  }),
                                ),
                                pinned: true),
                          ];
                        },
                        body: Container(
                          color: myLoading.isDark ? ColorRes.colorPrimary : ColorRes.greyShade100,
                          child: isBlock && !isMyProfile
                              ? DataNotFound()
                              : PageView(
                                  controller: pageController,
                                  physics: BouncingScrollPhysics(),
                                  onPageChanged: (value) {
                                    myLoading.setProfilePageIndex(value);
                                  },
                                  children: [
                                    ProfileVideoScreen(0, userId, isMyProfile),
                                    ProfileVideoScreen(1, userId, isMyProfile),
                                  ],
                                ),
                        ),
                      ),
              ),
              Visibility(
                visible: myLoading.isBigProfile,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        myLoading.setIsBigProfile(false);
                      },
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
                          child: SizedBox(),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.network(
                        ConstRes.itemBaseUrl + (userData?.userProfile ?? ''),
                        fit: BoxFit.cover,
                        height: 250,
                        width: 250,
                        errorBuilder: (context, error, stackTrace) {
                          return ImagePlaceHolder(
                            fontSize: 70,
                            heightWeight: 250,
                            name: userData?.fullName?[0],
                          );
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  double getTotalHeight(UserData? data) {
    double height = 490;
    if (data != null) {
      if (data.profileCategoryName == null || data.profileCategoryName!.isEmpty) height -= 20;
      if ((data.youtubeUrl == null || data.youtubeUrl!.isEmpty) && (data.fbUrl == null || data.fbUrl!.isEmpty) && (data.instaUrl == null || data.instaUrl!.isEmpty)) height -= 30;
      if (data.bio == null || data.bio!.isEmpty) height -= 40;
    }
    return height;
  }

  void getUserProfile() {
    isLoading = true;
    ApiService().getProfile(widget.type == 0 ? SessionManager.userId.toString() : widget.userId).then((value) {
      isLoading = false;
      if (value.status == 200) {
        if (widget.userId == SessionManager.userId.toString()) {
          Provider.of<MyLoading>(context, listen: false).setUser(value);
        }
        userData = value.data;

        isBlock = userData?.blockOrNot == 1;
        setState(() {});
      }
    });
  }

  void onChatIconClick() {
    var time = DateTime.now().millisecondsSinceEpoch.toDouble();
    ChatUser chatUser = ChatUser(
        date: time,
        image: userData?.userProfile,
        isNewMsg: false,
        isVerified: userData?.isVerify == 1 ? true : false,
        userFullName: userData?.fullName,
        userid: userData?.userId,
        userIdentity: userData?.identity,
        username: userData?.userName);
    Conversation conversation = Conversation(
        user: chatUser,
        block: false,
        blockFromOther: false,
        conversationId: '${userData?.identity}${_sessionManager.getUser()?.data?.identity}',
        deletedId: '',
        isDeleted: false,
        isMute: false,
        lastMsg: '',
        newMsg: '',
        time: time);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(user: conversation),
      ),
    ).then((value) {
      getUserProfile();
    });
  }

  void onFollowUnFollowClick(bool p1) {
    UserData? _userData = userData;
    if (p1) {
      _userData?.addFollowerCount();
    } else {
      _userData?.removeFollowerCount();
    }
    getUserProfile();
    userData = _userData;
  }

  void onEditProfileClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(),
      ),
    ).then((value) {
      getUserProfile();
    });
  }

  void blockApiCall() {
    ApiService().blockUser('${userData?.userId ?? -1}').then((value) {
      isBlock = !isBlock;
      setState(() {});
    });
  }

  @override
  Future<void> dispose() async {
    pageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  Consumer<MyLoading> consumer;

  _SliverAppBarDelegate({required this.consumer});

  @override
  double get minExtent => 52;

  @override
  double get maxExtent => 52;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return consumer;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class SocialButton extends StatelessWidget {
  final String? url;
  final String icon;
  final MyLoading myLoading;

  const SocialButton({Key? key, required this.url, required this.icon, required this.myLoading});

  @override
  Widget build(BuildContext context) {
    return url == null || url!.isEmpty
        ? SizedBox()
        : InkWell(
            onTap: () async {
              await canLaunchUrl(Uri.parse(url!)) ? await launchUrl(Uri.parse(url!)) : CommonUI.showToast(msg: LKey.invalidUrl.tr);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Image(
                    image: AssetImage(icon),
                    height: 20,
                    width: 20,
                    color: myLoading.isDark ? ColorRes.white : ColorRes.colorPrimaryDark,
                  ),
                  SizedBox(width: 10)
                ],
              ),
            ),
          );
  }
}
