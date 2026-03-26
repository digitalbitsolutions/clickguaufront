import 'dart:collection';
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
import 'package:bubbly/view/email/sign_up_screen.dart';
import 'package:bubbly/view/email/widget/forgot_password.dart';
import 'package:bubbly/view/email/widget/login_text_filed.dart';
import 'package:bubbly/view/main/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController resetPassController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode resetFocusNode = FocusNode();

  @override
  void initState() {
    initSessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                              myLoading.isDark ? icLogo : icLogoLight,
                              height: 100,
                              width: 100),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            '${LKey.signInFor.tr} $appName',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: FontRes.fNSfUiSemiBold,
                                color: ColorRes.colorTextLight),
                          ),
                        ),
                        SizedBox(height: 30),
                        _title(title: LKey.enterYourMail.tr),
                        const SizedBox(height: 10),
                        LoginTextFiled(
                            focusNode: emailFocus,
                            controller: emailController,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            isDarkMode: myLoading.isDark),
                        const SizedBox(height: 20),
                        _title(title: LKey.password.tr),
                        const SizedBox(height: 10),
                        LoginTextFiled(
                            focusNode: passwordFocus,
                            controller: passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            isDarkMode: myLoading.isDark),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleWidget(),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                emailController.clear();
                                passwordController.clear();
                                emailFocus.unfocus();
                                passwordFocus.unfocus();

                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return ForgotPassword(
                                      resetPassController: resetPassController,
                                      onResetBtnClick: resetPassword,
                                      resetFocusNode: resetFocusNode,
                                    );
                                  },
                                );
                              },
                              child: _title(
                                title: LKey.forgotPassword.tr,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: InkWell(
                            onTap: () => onLoginBtnClick(myLoading),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 38, vertical: 10),
                              decoration: BoxDecoration(
                                color: ColorRes.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorRes.colorPink,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                    spreadRadius: 0.5,
                                  ),
                                ],
                              ),
                              child: _title(
                                title: LKey.login.tr,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleWidget(),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                emailController.clear();
                                passwordController.clear();
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return SignUpScreen();
                                  },
                                ));
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: LKey.donTHaveAccount.tr,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontFamily: FontRes.fNSfUiLight),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' ${LKey.signUp.tr}',
                                        style: TextStyle(
                                            fontFamily: FontRes.fNSfUiBold,
                                            color: ColorRes.colorPink,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        PrivacyPolicyView(),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _title(
      {required String title,
      String fontFamily = FontRes.fNSfUiMedium,
      double fontSize = 15}) {
    return Text(
      title,
      style: TextStyle(
        color: ColorRes.colorTextLight,
        fontFamily: fontFamily,
        fontSize: fontSize,
      ),
    );
  }

  final SessionManager sessionManager = SessionManager();

  //SIGN IN METHOD
  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      CommonUI.showToast(msg: e.message.toString());
      return null;
    }
  }

  void onLoginBtnClick(MyLoading myLoading) async {
    unFocusField();
    if (emailController.text.trim().isEmpty) {
      return CommonUI.showToast(msg: LKey.pleaseEnterEmail.tr);
    }
    if (!emailController.text.trim().isValidEmail()) {
      return CommonUI.showToast(msg: LKey.pleaseEnterCorrectEmail.tr);
    }
    if (passwordController.text.trim().isEmpty) {
      return CommonUI.showToast(msg: LKey.pleaseEnterPassword.tr);
    }
    CommonUI.showLoader(context);
    signIn(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((value) async {
      if (value == null) return;
      if (value.user?.email == emailController.text.trim()) {
        if (value.user?.emailVerified == true) {
          sessionManager.saveString(
              KeyRes.password, passwordController.text.trim());
          HashMap<String, String?> params = HashMap();
          params[UrlRes.deviceToken] =
              sessionManager.getString(KeyRes.deviceToken);
          params[UrlRes.userEmail] = value.user?.email;
          params[UrlRes.fullName] = 'as';
          params[UrlRes.loginType] = KeyRes.email;
          params[UrlRes.userName] = value.user?.email != null
              ? value.user?.email!.split('@')[0]
              : value.user?.uid;
          params[UrlRes.identity] = value.user?.email ?? value.user?.uid;
          params[UrlRes.platform] = Platform.isAndroid ? "1" : "2";

          await ApiService().registerUser(params).then((value) async {
            Navigator.pop(context);
            if (value.status == 200) {
              sessionManager.saveBoolean(KeyRes.login, true);
              CommonUI.showToast(msg: value.message.toString());
              myLoading.setSelectedItem(0);
              myLoading.setUser(value);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                  (Route<dynamic> route) => false);
            } else {
              CommonUI.showToast(msg: value.message.toString());
            }
          });
        } else {
          Navigator.pop(context);
          CommonUI.showToast(msg: LKey.pleaseVerifiedYourEmail.tr);
        }
      } else {
        CommonUI.showToast(msg: LKey.emailNotFound.tr);
      }
    });
  }

  void unFocusField() {
    emailFocus.unfocus();
    passwordFocus.unfocus();
  }

  Future<void> resetPassword() async {
    resetFocusNode.unfocus();
    if (resetPassController.text.trim().isEmpty) {
      CommonUI.showToast(msg: LKey.pleaseEnterEmail.tr);
      return;
    } else if (!resetPassController.text.trim().isValidEmail()) {
      CommonUI.showToast(msg: LKey.pleaseEnterValidEmailAddress.tr);
      return;
    }
    try {
      await _auth.sendPasswordResetEmail(
          email: resetPassController.text.trim());
      resetPassController.clear();
      Navigator.pop(context);
      CommonUI.showToast(msg: LKey.emailSentSuccessfully.tr);
    } on FirebaseAuthException catch (e) {
      CommonUI.showToast(msg: "${e.message}");
    }
  }

  void initSessionManager() async {
    await sessionManager.initPref();
  }
}

class CircleWidget extends StatelessWidget {
  const CircleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: ColorRes.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: ColorRes.colorPink,
            blurRadius: 4,
            offset: Offset(1, 1),
            spreadRadius: 0.2,
          ),
        ],
      ),
    );
  }
}
