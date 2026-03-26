import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppBarCustom extends StatelessWidget {
  final String title;

  const AppBarCustom({Key? key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(
      builder: (context, value, child) => Container(
        color: value.isDark ? ColorRes.colorPrimaryDark : ColorRes.white,
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        size: 35,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20, fontFamily: FontRes.fNSfUiMedium),
                  ),
                ],
              ),
            ),
            Container(
              height: 0.3,
              color: value.isDark
                  ? ColorRes.colorTextLight
                  : ColorRes.colorPrimaryDark,
            ),
          ],
        ),
      ),
    );
  }
}
