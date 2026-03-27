import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/privacy_policy_view.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:bubbly/view/email/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginSheet extends StatelessWidget {
  final SessionManager sessionManager = SessionManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    initData();
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Container(
        height: (MediaQuery.of(context).size.height -
            AppBar().preferredSize.height * 1.5),
        decoration: BoxDecoration(
            color:
                myLoading.isDark ? ColorRes.colorPrimaryDark : ColorRes.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.close_rounded),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Image.asset(
                            myLoading.isDark ? icLogo : icLogoLight,
                            height: 90)),
                    Text('${LKey.signUpFor.tr} $appName',
                        style: TextStyle(
                            fontSize: 22, fontFamily: FontRes.fNSfUiSemiBold)),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                          LKey.createAProfileFollowOtherCreatorsNBuildYourFanFollowingBy
                              .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontFamily: FontRes.fNSfUiLight)),
                    ),
                    SizedBox(height: 15),
                    Visibility(
                      visible: Platform.isIOS,
                      child: SocialButton(
                          onTap: () {
                            CommonUI.showLoader(context);
                            _signInWithApple().then(
                              (value) {
                                CommonUI.hideLoader();
                                if (value != null) {
                                  _callApiForLogin(
                                      value, KeyRes.apple, context, myLoading);
                                } else {
                                  CommonUI.showToast(
                                      msg: LKey.somethingWentWrong.tr);
                                }
                              },
                            );
                          },
                          image: icApple,
                          isDarkMode: myLoading.isDark,
                          name: LKey.singInWithApple.tr),
                    ),
                    SocialButton(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              )).then((value) {});
                        },
                        isDarkMode: myLoading.isDark,
                        image: icEmail,
                        name: LKey.singInWithEmail.tr),
                    SocialButton(
                        onTap: () {
                          _handleGoogleSignIn(context, myLoading);
                        },
                        isGoogleIcon: true,
                        isDarkMode: myLoading.isDark,
                        image: icGoogle,
                        name: LKey.singInWithGoogle.tr),
                    SizedBox(height: 15),
                    PrivacyPolicyView(),
                    SizedBox(height: AppBar().preferredSize.height / 2),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn().timeout(
                const Duration(seconds: 30),
              );
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication.timeout(
        const Duration(seconds: 30),
      );
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Google Sign-In did not return valid tokens.');
      }

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult = await _auth.signInWithCredential(googleCredential)
          .timeout(const Duration(seconds: 30));
      return authResult.user;
    } on PlatformException catch (e) {
      throw Exception(_googleSignInErrorMessage(e));
    } on FirebaseAuthException catch (e) {
      throw Exception(
        e.message?.isNotEmpty == true
            ? e.message!
            : 'Google Sign-In failed.',
      );
    } on TimeoutException {
      throw Exception(
        'Google Sign-In timed out. Please try again.',
      );
    }
  }

  Future<void> _handleGoogleSignIn(
      BuildContext context, MyLoading myLoading) async {
    CommonUI.showLoader(context);
    try {
      final value = await _signInWithGoogle();
      if (value == null) {
        CommonUI.showToast(msg: 'Google Sign-In was cancelled.');
        return;
      }

      CommonUI.hideLoader();
      await _callApiForLoginInternal(value, KeyRes.google, context, myLoading);
    } catch (e) {
      CommonUI.showToast(
        msg:
            e.toString().isNotEmpty ? e.toString() : LKey.somethingWentWrong.tr,
      );
    } finally {
      CommonUI.hideLoader();
    }
  }

  String _googleSignInErrorMessage(PlatformException error) {
    final lowerMessage = (error.message ?? '').toLowerCase();
    final lowerCode = error.code.toLowerCase();

    if (lowerCode.contains('sign_in_failed') ||
        lowerMessage.contains('apiexception: 10') ||
        lowerMessage.contains('12500')) {
      return 'Google Sign-In is not configured for this Android build.';
    }
    if (lowerCode.contains('network_error') || lowerMessage.contains('network')) {
      return 'Google Sign-In failed because of a network error.';
    }
    if (lowerCode.contains('sign_in_canceled') ||
        lowerCode.contains('canceled') ||
        lowerCode.contains('cancelled')) {
      return 'Google Sign-In was cancelled.';
    }

    return error.message?.isNotEmpty == true
        ? error.message!
        : 'Google Sign-In failed.';
  }

  Future<User?> _signInWithApple() async {
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ]);
      final oauthCredential = OAuthProvider("apple.com")
          .credential(idToken: appleCredential.identityToken);
      String? displayName =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      String? userEmail = '${appleCredential.email}';
      final authResult = await _auth.signInWithCredential(oauthCredential);
      final firebaseUser = authResult.user;

      if (displayName.isNotEmpty && firebaseUser?.displayName == null) {
        await firebaseUser?.updateDisplayName(displayName);
      }
      if (userEmail.isNotEmpty && firebaseUser?.email == null) {
        await firebaseUser?.updateEmail(userEmail);
      }
      return firebaseUser;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  void _callApiForLogin(
      User value, String loginType, BuildContext context, MyLoading myLoading) {
    _callApiForLoginInternal(value, loginType, context, myLoading);
  }

  Future<void> _callApiForLoginInternal(User value, String loginType,
      BuildContext context, MyLoading myLoading) async {
    HashMap<String, String?> params = new HashMap();
    params[UrlRes.deviceToken] = sessionManager.getString(KeyRes.deviceToken);
    params[UrlRes.userEmail] = value.email ??
        value.displayName!
                .split('@')[value.displayName!.split('@').length - 1] +
            '@fb.com';
    params[UrlRes.fullName] = value.displayName;
    params[UrlRes.loginType] = loginType;
    params[UrlRes.userName] =
        value.email != null ? value.email!.split('@')[0] : value.uid;
    params[UrlRes.identity] = value.email ?? value.uid;
    params[UrlRes.platform] = Platform.isAndroid ? "1" : "2";
    CommonUI.showLoader(context);
    try {
      final user = await ApiService().registerUser(params);
      if (user.status == 200) {
        sessionManager.saveBoolean(KeyRes.login, true);
        myLoading.setSelectedItem(0);
        myLoading.setUser(user);
        Navigator.pop(context);
      } else {
        CommonUI.showToast(
          msg: user.message?.isNotEmpty == true
              ? user.message.toString()
              : LKey.somethingWentWrong.tr,
        );
      }
    } catch (e) {
      CommonUI.showToast(
        msg:
            e.toString().isNotEmpty ? e.toString() : LKey.somethingWentWrong.tr,
      );
    } finally {
      CommonUI.hideLoader();
    }
  }

  Future<void> initData() async {
    await sessionManager.initPref();
  }
}

class SocialButton extends StatelessWidget {
  final VoidCallback onTap;
  final String image;
  final String name;
  final bool isDarkMode;
  final bool isGoogleIcon;

  const SocialButton(
      {Key? key,
      required this.onTap,
      required this.image,
      required this.name,
      required this.isDarkMode,
      this.isGoogleIcon = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 210,
        margin: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: isDarkMode ? ColorRes.colorPrimary : ColorRes.greyShade100,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Image.asset(image,
                  height: 23,
                  color: isGoogleIcon
                      ? null
                      : isDarkMode
                          ? ColorRes.white
                          : Colors.black),
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 14,
                fontFamily: FontRes.fNSfUiMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}
