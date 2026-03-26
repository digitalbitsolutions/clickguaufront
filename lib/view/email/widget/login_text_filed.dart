import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:flutter/material.dart';

class LoginTextFiled extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool isDarkMode;

  const LoginTextFiled(
      {Key? key,
      required this.controller,
      required this.focusNode,
      required this.obscureText,
      required this.keyboardType,
      this.textCapitalization = TextCapitalization.none,
      required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: isDarkMode ? ColorRes.colorPrimary : ColorRes.greyShade100,
          borderRadius: BorderRadius.circular(5)),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
        cursorColor: ColorRes.colorTextLight,
        cursorHeight: 15,
        style: TextStyle(
            color: ColorRes.colorTextLight,
            fontSize: 15,
            fontFamily: FontRes.fNSfUiMedium),
      ),
    );
  }
}
