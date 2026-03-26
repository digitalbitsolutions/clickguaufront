import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DataNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 55,
                child: Image(
                  image: AssetImage(
                    myLoading.isDark ? icLogo : icLogoLight,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                LKey.nothingToShow.tr,
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: FontRes.fNSfUiBold,
                    color: ColorRes.colorTextLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
