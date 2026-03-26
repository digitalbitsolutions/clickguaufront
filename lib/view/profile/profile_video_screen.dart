import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/dialog/confirmation_dialog.dart';
import 'package:bubbly/view/profile/item_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfileVideoScreen extends StatefulWidget {
  final int type;
  final String? userId;
  final bool isMyProfile;

  ProfileVideoScreen(
    this.type,
    this.userId,
    this.isMyProfile,
  );

  @override
  _ProfileVideoScreenState createState() => _ProfileVideoScreenState();
}

class _ProfileVideoScreenState extends State<ProfileVideoScreen> {
  List<Data> _profileData = [];
  bool isLoading = true;
  bool hasMoreData = true;
  bool isLoadFirstTime = true;

  @override
  void initState() {
    print('Calling');
    _profileData = [];
    callApi();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<MyLoading>(
          builder: (context, value, child) {
            if (value.isScrollProfileVideo &&
                value.getProfilePageIndex == widget.type) {
              if (!isLoading) {
                callApi();
              }
            }
            return Container(height: 0);
          },
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            child: isLoadFirstTime
                ? GridView(
                    primary: false,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 1 / 1.3),
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(left: 10, bottom: 20),
                    children: List.generate(6, (index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.2),
                        highlightColor: ColorRes.colorLight.withOpacity(0.2),
                        direction: ShimmerDirection.ltr,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: ColorRes.colorPrimaryDark,
                          ),
                          margin: EdgeInsets.only(top: 10, right: 10),
                        ),
                      );
                    }),
                  )
                : _profileData.isEmpty
                    ? DataNotFound()
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1 / 1.3,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                        scrollDirection: Axis.vertical,
                        itemCount: _profileData.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onLongPress: () => onLongPressOnPost(index),
                            child: ItemPost(
                                data: _profileData[index],
                                list: _profileData,
                                type: widget.type + 1,
                                userId: widget.userId),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }

  void onLongPressOnPost(int index) {
    if (widget.type == 0 && widget.isMyProfile)
      showDialog(
        context: context,
        builder: (c) {
          return ConfirmationDialog(
            aspectRatio: 1.8,
            title1: LKey.removePost.tr,
            title2: LKey.areYouSureNWantToRemovePost.tr,
            positiveText: LKey.delete.tr,
            onPositiveTap: () async {
              Navigator.pop(context);
              CommonUI.showLoader(context);
              ApiService()
                  .deletePost(_profileData[index].postId.toString())
                  .then(
                (value) {
                  Navigator.pop(context);
                  _profileData.remove(_profileData[index]);
                  setState(() {});
                },
              );
            },
          );
        },
      );
  }

  void callApi() {
    if (!hasMoreData) {
      return;
    }
    if (isLoadFirstTime) {
      isLoadFirstTime = true;
    }
    isLoading = true;

    ApiService()
        .getUserVideos('${_profileData.length}', '$paginationLimit',
            widget.userId, widget.type)
        .then((value) {
      setState(() {
        if ((value.data?.length ?? 0) < paginationLimit) {
          hasMoreData = false;
        }
        isLoadFirstTime = false;
        _profileData.addAll(value.data ?? []);

        isLoading = false;
      });
    });
  }
}
