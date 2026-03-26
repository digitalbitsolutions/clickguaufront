import 'package:bubbly/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CommonUI {
  static void showToast(
      {required String msg,
      ToastGravity? toastGravity,
      int duration = 1,
      Color? backGroundColor}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: toastGravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration,
      backgroundColor: backGroundColor ?? ColorRes.colorPink,
      textColor: ColorRes.white,
      fontSize: 15.0,
    );
  }

  static void showLoader(BuildContext context) {
    Get.dialog(LoaderDialog());
  }
}

class LoaderDialog extends StatelessWidget {
  final double strokeWidth;

  LoaderDialog({this.strokeWidth = 4});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: ColorRes.colorTheme,
        strokeWidth: strokeWidth,
      ),
    );
  }
}
