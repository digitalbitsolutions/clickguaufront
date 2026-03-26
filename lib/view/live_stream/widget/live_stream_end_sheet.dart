import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:flutter/material.dart';

class LiveStreamEndSheet extends StatelessWidget {
  final String name;
  final VoidCallback onExitBtn;

  const LiveStreamEndSheet(
      {Key? key, required this.name, required this.onExitBtn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: ColorRes.colorPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: EdgeInsets.all(15),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: onExitBtn,
                child: Icon(Icons.close, color: ColorRes.white),
              ),
            ),
            Spacer(),
            Text(
              name,
              style: TextStyle(
                  color: ColorRes.white,
                  fontSize: 20,
                  fontFamily: FontRes.fNSfUiBold),
            ),
            Text(
              'Live Stream Ended',
              style: TextStyle(
                  color: ColorRes.white,
                  fontSize: 19,
                  fontFamily: FontRes.fNSfUiRegular),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
