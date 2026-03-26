import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/login/login_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowUnFollowButton extends StatefulWidget {
  final UserData? data;
  final Function(bool) followClick;
  final bool isLogin;
  final bool isDarkMode;

  const FollowUnFollowButton(
      {this.data,
      required this.followClick,
      required this.isLogin,
      required this.isDarkMode});

  @override
  _FollowUnFollowButtonState createState() => _FollowUnFollowButtonState();
}

class _FollowUnFollowButtonState extends State<FollowUnFollowButton> {
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    isFollowing = widget.data!.isFollowing == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (SessionManager.userId == -1 || !widget.isLogin) {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return LoginSheet();
            },
          ).then((value) {
            Navigator.pop(context);
          });
          return;
        }
        isLoading = true;
        setState(() {});
        ApiService().followUnFollowUser(widget.data!.userId.toString()).then(
          (value) {
            if (value.status == 200) {
              isLoading = false;
              isFollowing = !isFollowing;
              setState(() {});
              widget.followClick(isFollowing);
            }
          },
        );
      },
      child: FittedBox(
        child: Container(
          height: 38,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLoading
                    ? [
                        ColorRes.colorPrimary,
                        ColorRes.colorPrimary,
                      ]
                    : !isFollowing
                        ? [
                            ColorRes.colorTheme,
                            ColorRes.colorPink,
                          ]
                        : !widget.isDarkMode
                            ? [
                                ColorRes.greyShade100,
                                ColorRes.greyShade100,
                              ]
                            : [
                                ColorRes.colorPrimary,
                                ColorRes.colorPrimary,
                              ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          alignment: Alignment.center,
          child: isLoading
              ? Container(
                  height: 20,
                  width: 20,
                  child: LoaderDialog(strokeWidth: 2),
                )
              : Text(
                  isFollowing ? LKey.unfollow.tr : LKey.follow.tr,
                  style: TextStyle(
                    fontFamily: FontRes.fNSfUiMedium,
                    color:
                        isFollowing ? ColorRes.colorTextLight : ColorRes.white,
                  ),
                ),
        ),
      ),
    );
  }
}
