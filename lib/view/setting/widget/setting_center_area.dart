import 'dart:developer';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/main.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/firebase_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:bubbly/view/dialog/confirmation_dialog.dart';
import 'package:bubbly/view/languages_screen/languages_screen.dart';
import 'package:bubbly/view/qrcode/my_qr_code_screen.dart';
import 'package:bubbly/view/verification/verification_screen.dart';
import 'package:bubbly/view/wallet/wallet_screen.dart';
import 'package:bubbly/view/webview/webview_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingCenterArea extends StatefulWidget {
  const SettingCenterArea({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingCenterArea> createState() => _SettingCenterAreaState();
}

class _SettingCenterAreaState extends State<SettingCenterArea> {
  SessionManager sessionManager = SessionManager();
  int followers = 0;
  User? user;
  final db = FirebaseFirestore.instance;
  bool isNotifyMe = false;
  SettingData? settingData;

  @override
  void initState() {
    prefData();
    super.initState();
  }

  void prefData() async {
    await sessionManager.initPref();
    user = sessionManager.getUser();
    settingData = sessionManager.getSetting()?.data;

    ApiService().fetchSettingsData().then((value) {
      settingData = value.data;
    });

    isNotifyMe = user?.data?.isNotification == 0 ? false : true;
    followers = sessionManager.getUser()?.data?.followersCount ?? 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    HeadingText(heading: LKey.account.tr),
                    Container(
                      decoration: BoxDecoration(
                        color: myLoading.isDark
                            ? ColorRes.colorPrimary
                            : ColorRes.greyShade100,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          HeadingWithSwitch(
                            image: icNotificationBorder,
                            title: LKey.notifyMe.tr,
                            isOn: isNotifyMe,
                            onChanged: (value) async {
                              isNotifyMe = value;
                              String notificationValue = isNotifyMe ? '1' : '0';
                              ApiService()
                                  .updateProfile(
                                      isNotification: notificationValue)
                                  .then((value) {
                                log('notification : ${value.data?.isNotification}');
                              });
                              setState(() {});
                            },
                          ),
                          HeadingWithSwitch(
                            image: icNightMode,
                            title: LKey.darkMode.tr,
                            isOn: myLoading.isDark,
                            onChanged: (value) {
                              myLoading.isDark
                                  ? myLoading.setDarkMode(false)
                                  : myLoading.setDarkMode(true);
                            },
                          ),
                          ItemSetting(
                            text: LKey.languages.tr,
                            image: icTranslate,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LanguagesScreen()));
                            },
                          ),
                          ItemSetting(
                            text: LKey.shareProfile.tr,
                            image: icShareBorder,
                            onTap: shareLink,
                          ),
                          ItemSetting(
                            text: LKey.myQrCode.tr,
                            image: icQrCode,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MyQrScanCodeScreen()));
                            },
                          ),
                          ItemSetting(
                            text: LKey.wallet.tr,
                            image: icWallet,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WalletScreen()));
                            },
                          ),
                          Visibility(
                            visible: myLoading.getUser?.data?.isVerify == 0,
                            child: ItemSetting(
                              text: LKey.requestVerification.tr,
                              image: icVerified,
                              onTap: () {
                                if ((settingData?.minFansVerification ?? 0) >
                                    followers) {
                                  return CommonUI.showToast(
                                      msg:
                                          '${LKey.minimumFollower.tr} ${settingData?.minFansVerification}');
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VerificationScreen()));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    HeadingText(heading: LKey.general.tr),
                    Container(
                      decoration: BoxDecoration(
                        color: myLoading.isDark
                            ? ColorRes.colorPrimary
                            : ColorRes.greyShade100,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        children: [
                          ItemSetting(
                            text: LKey.help.tr,
                            image: icHelp,
                            onTap: () async {
                              final Uri params = Uri(
                                scheme: 'mailto',
                                path: settingData?.helpMail ?? '',
                              );
                              if (await canLaunchUrl(params)) {
                                await launchUrl(params);
                              } else {
                                print('Could not launch ${params.toString()}');
                              }
                            },
                          ),
                          ItemSetting(
                            text: LKey.termsOfUse.tr,
                            image: icTerms,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(2),
                                ),
                              );
                            },
                          ),
                          ItemSetting(
                            text: LKey.privacyPolicy.tr,
                            image: icPrivacy,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(3),
                                ),
                              );
                            },
                          ),
                          ItemSetting(
                            text: LKey.deleteAccount.tr,
                            image: icRemoveAccount,
                            onTap: () => onDeleteAccount(myLoading),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => onLogoutTap(myLoading),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 15, vertical: 5)),
                    backgroundColor: MaterialStateProperty.all(myLoading.isDark
                        ? ColorRes.colorPrimary
                        : ColorRes.greyShade100),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircleAvatar(
                          child: Icon(
                            Icons.power_settings_new,
                            color: ColorRes.white,
                            size: 15,
                          ),
                          backgroundColor: ColorRes.colorIcon,
                          radius: 10,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          LKey.logOut.tr.toUpperCase(),
                          style: TextStyle(
                            color: ColorRes.colorIcon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void logOutUser(BuildContext context) {
    ApiService().logoutUser().then(
      (value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyBubblyApp()),
            (Route<dynamic> route) => false);
      },
    );
  }

  void shareLink() async {
    User user = Provider.of<MyLoading>(context, listen: false).getUser!;
    BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier: 'flutter/branch',
        title: user.data!.userName!,
        imageUrl: ConstRes.itemBaseUrl + user.data!.userProfile!,
        contentDescription: '',
        publiclyIndex: true,
        locallyIndex: true,
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata(UrlRes.userId, user.data!.userId));
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
        subject: '${AppRes.look} ${user.data!.userName}',
      );
    } else {
      print('Error : ${response.errorCode} - ${response.errorMessage}');
    }
  }

  void onLogoutTap(MyLoading myLoading) {
    showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            aspectRatio: 1.8,
            title1: LKey.areYouSure.tr,
            title2: LKey.doYoReallyNWantToLogOut.tr,
            positiveText: LKey.confirm.tr,
            onPositiveTap: () async {
              if (myLoading.getUser?.data?.loginType == "0") {
                logOutUser(context);
              } else {
                GoogleSignIn().signOut().then((value) {
                  logOutUser(context);
                });
              }
            },
          );
        });
  }

  onDeleteAccount(MyLoading myLoading) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        aspectRatio: 1.5,
        title1: LKey.areYouSure.tr,
        title2: LKey.allOfYourDataIncludingPostsNLikesFollowsAndEverything.tr,
        positiveText: LKey.confirm.tr,
        onPositiveTap: () async {
          if (user?.data?.loginType == KeyRes.email) {
            await auth.FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: user?.data?.identity ?? '',
                    password: sessionManager.getString(KeyRes.password) ?? '')
                .then((value) {
              value.user?.delete();
            });
          }
          ApiService().deleteAccount().then(
            (value) async {
              await db
                  .collection(FirebaseRes.userChatList)
                  .doc(user?.data?.identity)
                  .collection(FirebaseRes.userList)
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  db
                      .collection(FirebaseRes.userChatList)
                      .doc(element.id)
                      .collection(FirebaseRes.userList)
                      .doc(user?.data?.identity)
                      .update({
                    FirebaseRes.isDeleted: true,
                    FirebaseRes.deletedId:
                        '${DateTime.now().millisecondsSinceEpoch}',
                    FirebaseRes.block: false,
                    FirebaseRes.blockFromOther: false,
                  });
                  db
                      .collection(FirebaseRes.userChatList)
                      .doc(user?.data?.identity)
                      .collection(FirebaseRes.userList)
                      .doc(element.id)
                      .update({
                    FirebaseRes.isDeleted: true,
                    FirebaseRes.deletedId:
                        '${DateTime.now().millisecondsSinceEpoch}',
                    FirebaseRes.block: false,
                    FirebaseRes.blockFromOther: false,
                  });
                });
              });
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyBubblyApp()),
                  (Route<dynamic> route) => false);
            },
          );
        },
      ),
    );
  }
}

class HeadingText extends StatelessWidget {
  final String heading;

  const HeadingText({Key? key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: ColorRes.colorIcon,
            radius: 5,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            heading,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemSetting extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback onTap;

  ItemSetting({required this.text, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 16,
              color: ColorRes.colorIcon,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontRes.fNSfUiMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeadingWithSwitch extends StatelessWidget {
  final bool isOn;
  final Function(bool value) onChanged;
  final String image;
  final String title;

  const HeadingWithSwitch(
      {Key? key,
      required this.isOn,
      required this.onChanged,
      required this.image,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        children: [
          Image.asset(
            image,
            height: 17,
            color: ColorRes.colorIcon,
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontRes.fNSfUiMedium,
              ),
            ),
          ),
          Switch(
            onChanged: onChanged,
            value: isOn,
            activeTrackColor: ColorRes.colorPink,
            inactiveTrackColor: Colors.grey,
            thumbColor: MaterialStateProperty.all(
                isOn ? ColorRes.colorPink : ColorRes.greyShade100),
          )
        ],
      ),
    );
  }
}

class NotificationSwitch extends StatefulWidget {
  final bool isOn;
  final Function(bool value) onChanged;

  NotificationSwitch(this.isOn, this.onChanged);

  @override
  _NotificationSwitchState createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  bool currentValue = true;
  SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    initSessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      onChanged: widget.onChanged,
      value: widget.isOn,
    );
  }

  void initSessionManager() async {
    await _sessionManager.initPref();
  }
}
