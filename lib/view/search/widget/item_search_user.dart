import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/search/search_user.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemSearchUser extends StatelessWidget {
  final SearchUserData? searchUser;

  ItemSearchUser(this.searchUser);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
              type: 1, userId: searchUser?.userId.toString() ?? '-1'),
        ),
      ),
      child: Container(
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
                    ConstRes.itemBaseUrl +
                        (searchUser?.userProfile == null ||
                                searchUser!.userProfile!.isEmpty
                            ? ''
                            : searchUser?.userProfile ?? ''),
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                    errorBuilder: (context, error, stackTrace) {
                      return ImagePlaceHolder(
                        name: searchUser?.fullName,
                        fontSize: 25,
                        heightWeight: 60,
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        searchUser?.fullName ?? '',
                        style: TextStyle(
                          fontFamily: FontRes.fNSfUiMedium,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${AppRes.atSign}${searchUser?.userName}',
                        style: TextStyle(
                            color: ColorRes.colorTextLight,
                            fontFamily: FontRes.fNSfUiMedium,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        '${searchUser?.followersCount} ${LKey.fans.tr} ${searchUser?.myPostCount} ${LKey.videos.tr}',
                        style: TextStyle(
                          color: ColorRes.colorTheme,
                          fontFamily: FontRes.fNSfUiLight,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
