import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/modal/followers/follower_following_data.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:flutter/material.dart';

class ItemFollowers extends StatelessWidget {
  final FollowerUserData user;

  ItemFollowers(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              ClipOval(
                child: Image.network(
                  ConstRes.itemBaseUrl + user.userProfile!,
                  fit: BoxFit.cover,
                  height: 45,
                  width: 45,
                  errorBuilder: (context, error, stackTrace) {
                    return ImagePlaceHolder(
                      name: user.fullName,
                      heightWeight: 45,
                      fontSize: 25,
                    );
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName!,
                    style: TextStyle(
                      fontFamily: FontRes.fNSfUiMedium,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    '@${user.userName}',
                    style: TextStyle(
                      color: ColorRes.colorTextLight,
                      fontFamily: FontRes.fNSfUiRegular,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: ColorRes.colorTextLight,
            height: 0.2,
          ),
        ],
      ),
    );
  }
}
