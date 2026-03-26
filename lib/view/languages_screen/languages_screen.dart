import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LanguagesScreen extends StatefulWidget {
  const LanguagesScreen({Key? key}) : super(key: key);

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        body: Column(
          children: [
            AppBarCustom(title: LKey.languages.tr),
            Expanded(
              child: SafeArea(
                top: false,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: AppRes.languages.length,
                  itemBuilder: (context, index) {
                    return RadioListTile<int>(
                      value: index,
                      groupValue: AppRes.languages
                          .map((e) => e['key'])
                          .toList()
                          .indexOf(myLoading.languageCode),
                      dense: true,
                      fillColor: MaterialStateProperty.all(ColorRes.colorTheme),
                      tileColor: myLoading.isDark
                          ? ColorRes.colorPrimaryDark
                          : ColorRes.white,
                      onChanged: (int? value) {
                        myLoading.setLanguageCode(value ?? 0, context);
                      },
                      title: Text(
                        AppRes.languages[index]['title'],
                        style: TextStyle(
                            fontFamily: FontRes.fNSfUiSemiBold,
                            fontSize: 15,
                            color: myLoading.isDark
                                ? ColorRes.white
                                : ColorRes.colorPrimaryDark),
                      ),
                      subtitle: Text(
                        AppRes.languages[index]['subHeading'],
                        style: TextStyle(
                            fontFamily: FontRes.fNSfUiRegular,
                            color: myLoading.isDark
                                ? ColorRes.greyShade100
                                : ColorRes.colorPrimary),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
