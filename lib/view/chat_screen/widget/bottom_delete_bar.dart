import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomDeleteBar extends StatelessWidget {
  final List<String> timeStamp;
  final VoidCallback deleteBtnClick;
  final VoidCallback cancelBtnClick;

  const BottomDeleteBar(
      {Key? key,
      required this.timeStamp,
      required this.deleteBtnClick,
      required this.cancelBtnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(30)),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                cancelBtnClick();
              },
              child: Text(
                LKey.cancel.tr,
                style: TextStyle(
                    fontSize: 15,
                    color: ColorRes.colorTheme,
                    fontFamily: FontRes.fNSfUiSemiBold),
              ),
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                '${timeStamp.length} ',
                key: ValueKey<int>(timeStamp.length),
                style: const TextStyle(
                  fontFamily: FontRes.fNSfUiBold,
                  fontSize: 15,
                  color: ColorRes.white,
                ),
              ),
            ),
            Text(
              LKey.selected.tr,
              style: TextStyle(
                  fontSize: 15,
                  color: ColorRes.white,
                  fontFamily: FontRes.fNSfUiSemiBold),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                deleteBtnClick();
              },
              child: const Icon(
                Icons.delete,
                color: ColorRes.colorPink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
