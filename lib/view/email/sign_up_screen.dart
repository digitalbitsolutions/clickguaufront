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
import 'package:bubbly/view/email/widget/login_text_filed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmFocusNode = FocusNode();
  FocusNode referralFocusNode = FocusNode();

  FirebaseAuth auth = FirebaseAuth.instance;
  final SessionManager sessionManager = SessionManager();

  String fullNameError = '';
  String emailError = '';
  String passwordError = '';
  String confirmPasswordError = '';

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
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer(
                          builder: (context, MyLoading myLoading, child) =>
                              Center(
                            child: Image(
                              image: AssetImage(
                                  myLoading.isDark ? icLogo : icLogoLight),
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            '${LKey.signUpFor.tr} $appName',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: FontRes.fNSfUiSemiBold,
                                color: ColorRes.colorTextLight),
                          ),
                        ),
                        SizedBox(height: 30),
                        _title(title: LKey.enterYourName.tr),
                        const SizedBox(height: 10),
                        LoginTextFiled(
                            focusNode: nameFocusNode,
                            controller: nameController,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            isDarkMode: myLoading.isDark),
                        const SizedBox(height: 20),
                        _title(title: LKey.enterYourMail.tr),
                        const SizedBox(height: 10),
                        LoginTextFiled(
                            focusNode: emailFocusNode,
                            controller: emailController,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            isDarkMode: myLoading.isDark),
                        const SizedBox(height: 20),
                        _title(title: LKey.password.tr),
                        const SizedBox(height: 10),
                        LoginTextFiled(
                            focusNode: passwordFocusNode,
                            controller: passwordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            isDarkMode: myLoading.isDark),
                        const SizedBox(height: 20),
                        _title(title: LKey.confirmPassword.tr),
                        const SizedBox(height: 10),
                        LoginTextFiled(
                            focusNode: confirmFocusNode,
                            controller: confirmPasswordController,
                            obscureText: true,
                            keyboardType: TextInputType.visiblePassword,
                            isDarkMode: myLoading.isDark),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: InkWell(
                    onTap: onRegisterBtnClick,
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: AppBar().preferredSize.height / 2),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 38, vertical: 10),
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(
                            color: ColorRes.colorPink,
                            blurRadius: 4,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: _title(
                          title: LKey.register.tr,
                          fontFamily: FontRes.fNSfUiSemiBold),
                    ),
                  ),
                ),
                PrivacyPolicyView(),
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

  void initSessionManager() async {
    await sessionManager.initPref();
  }

  void unFocusField() {
    nameFocusNode.unfocus();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    confirmFocusNode.unfocus();
    referralFocusNode.unfocus();
  }

  Future<void> onRegisterBtnClick() async {
    unFocusField();
    bool isValidation = isValid();
    if (isValidation) {
      CommonUI.showLoader(context);
      await auth
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: confirmPasswordController.text.trim(),
      )
          .then((value) async {
        await value.user?.sendEmailVerification();
        HashMap<String, String?> params = new HashMap();
        params[UrlRes.deviceToken] =
            sessionManager.getString(KeyRes.deviceToken);
        params[UrlRes.userEmail] = value.user?.email;
        params[UrlRes.fullName] = nameController.text.trim();
        params[UrlRes.loginType] = KeyRes.email;
        params[UrlRes.userName] = value.user?.email != null
            ? value.user?.email!.split('@')[0]
            : value.user?.uid;
        params[UrlRes.identity] = value.user?.email ?? value.user?.uid;
        params[UrlRes.platform] = Platform.isAndroid ? "1" : "2";

        await ApiService().registerUser(params).then((value) async {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      }).onError((FirebaseAuthException e, s) {
        CommonUI.showToast(msg: e.message.toString());
        Navigator.pop(context);
      });
    }
    setState(() {});
  }

  bool isValid() {
    int count = 0;
    if (nameController.text.trim().isEmpty) {
      count++;
      CommonUI.showToast(msg: LKey.enterYourName.tr);
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      count++;
      CommonUI.showToast(msg: LKey.enterYourMail.tr);
      return false;
    }
    if (!emailController.text.trim().isValidEmail()) {
      count++;
      CommonUI.showToast(msg: LKey.pleaseEnterValidEmail.tr);
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      count++;
      CommonUI.showToast(msg: LKey.pleaseEnterPassword.tr);
      return false;
    }
    if (confirmPasswordController.text.trim().isEmpty) {
      count++;
      CommonUI.showToast(msg: LKey.enterReenterPassword.tr);
      return false;
    }
    if (passwordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      count++;
      CommonUI.showToast(msg: LKey.passwordDoseNotMatch.tr);
      return false;
    }
    return count == 0 ? true : false;
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\])|(([a-zA-Z\-\d]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
