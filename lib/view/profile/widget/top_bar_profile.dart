import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:bubbly/view/report/report_screen.dart';
import 'package:bubbly/view/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:share_plus/share_plus.dart';

class TopBarProfile extends StatelessWidget {
  final bool isDarkMode;
  final int profileType;
  final UserData? userData;
  final bool isMyProfile;
  final bool isBlock;
  final VoidCallback onBlockApiCall;

  const TopBarProfile(
      {Key? key,
      required this.isDarkMode,
      required this.profileType,
      this.userData,
      required this.isMyProfile,
      required this.isBlock,
      required this.onBlockApiCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Visibility(
            visible: profileType == 1,
            replacement: SizedBox(width: 30),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.chevron_left_rounded,
                size: 30,
                color: isDarkMode ? ColorRes.white : ColorRes.colorPrimaryDark,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                userData?.fullName ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color:
                      isDarkMode ? ColorRes.white : ColorRes.colorPrimaryDark,
                  fontFamily: FontRes.fNSfUiSemiBold,
                ),
              ),
            ),
          ),
          isMyProfile
              ? InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SettingScreen();
                        },
                      ),
                    );
                  },
                  child: Icon(
                    Icons.settings,
                    color:
                        isDarkMode ? ColorRes.white : ColorRes.colorPrimaryDark,
                    size: 23,
                  ),
                )
              : PopupMenuButton(
                  itemBuilder: (BuildContext context) {
                    return List.generate(
                      SessionManager.userId == -1 ? 2 : 3,
                      (index) {
                        return PopupMenuItem(
                          value: index,
                          child: Text(
                            index == 0
                                ? LKey.shareProfile.tr
                                : index == 1
                                    ? LKey.reportUser.tr
                                    : (isBlock
                                        ? LKey.unblockUser.tr
                                        : LKey.blockUser.tr),
                            style: TextStyle(
                              color: ColorRes.colorTextLight,
                              fontFamily: FontRes.fNSfUiMedium,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  onSelected: (int value) {
                    if (value == 0) {
                      shareLink(context);
                      return;
                    }
                    if (value == 1) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) =>
                            ReportScreen(2, '${userData?.userId ?? -1}'),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                      return;
                    }
                    if (value == 2) {
                      onBlockApiCall();
                    }
                  },
                  color: isDarkMode
                      ? ColorRes.colorPrimary
                      : ColorRes.greyShade100,
                  child: Image(
                    width: 30,
                    height: 20,
                    color:
                        isDarkMode ? ColorRes.white : ColorRes.colorPrimaryDark,
                    image: AssetImage(icMenu),
                  ),
                ),
        ],
      ),
    );
  }

  void shareLink(BuildContext context) async {
    UserData? user = userData;
    if (user == null) {
      return;
    }
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: user.userName ?? '',
        imageUrl: ConstRes.itemBaseUrl + user.userProfile!,
        contentDescription: '',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata(UrlRes.userId, user.userId));
    BranchLinkProperties lp = BranchLinkProperties(
        channel: 'facebook',
        feature: 'sharing',
        stage: 'new share',
        tags: ['one', 'two', 'three']);
    lp.addControlParam('url', 'http://www.google.com');
    lp.addControlParam('url2', 'http://flutter.dev');
    CommonUI.showLoader(context);
    BranchResponse response =
        await FlutterBranchSdk.getShortUrl(buo: buo, linkProperties: lp);
    Navigator.pop(context);
    if (response.success) {
      Share.share(
        AppRes.checkOutThisAmazingProfile(response.result),
        subject: '${AppRes.look} ${user.userName}',
      );
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }
}
