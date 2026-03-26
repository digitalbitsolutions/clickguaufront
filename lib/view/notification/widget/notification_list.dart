import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/notification/notification.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/profile/profile_screen.dart';
import 'package:bubbly/view/video/video_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  ScrollController _scrollController = ScrollController();
  List<NotificationData> notificationList = [];
  bool isLoading = true;
  bool hasMoreData = true;

  @override
  void initState() {
    callApiForNotificationList();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        if (!isLoading) {
          callApiForNotificationList();
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? LoaderDialog()
        : notificationList.isEmpty
            ? DataNotFound()
            : ListView.builder(
                controller: _scrollController,
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  NotificationData notificationData = notificationList[index];
                  return InkWell(
                    onTap: () {
                      if (notificationData.notificationType! >= 4) {
                        return;
                      }
                      if (notificationData.notificationType == 1 ||
                          notificationData.notificationType == 2) {
                        ///Video Screen
                        CommonUI.showLoader(context);
                        ApiService()
                            .getPostByPostId(notificationData.itemId.toString())
                            .then((value) {
                          Navigator.pop(context);
                          if (value.status == 401) {
                            CommonUI.showToast(msg: value.message!);
                          } else {
                            List<Data> list = [value.data!];
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return VideoListScreen(
                                  list: list, index: 0, type: 6);
                            }));
                          }
                        });
                      } else {
                        ///User Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              type: 1,
                              userId: '${notificationData.itemId ?? -1}',
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 55,
                                width: 55,
                                padding: EdgeInsets.all(1),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  color: Colors.transparent,
                                  child: ClipOval(
                                    child: Image.network(
                                      ConstRes.itemBaseUrl +
                                          "${notificationData.senderUser?.userProfile}",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return ImagePlaceHolder(
                                          name: notificationData
                                              .senderUser?.fullName,
                                          heightWeight: 40,
                                          fontSize: 35,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (notificationData.notificationType! >= 4
                                          ? LKey.admin.tr
                                          : notificationData
                                                  .senderUser?.fullName ??
                                              'Unknown'),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontFamily: FontRes.fNSfUiSemiBold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      (notificationData.message != null
                                          ? notificationData.message!
                                          : ''),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: ColorRes.colorTextLight,
                                        fontFamily: FontRes.fNSfUiLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Consumer(
                                builder:
                                    (context, MyLoading myLoading, child) =>
                                        Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image(
                                      image: AssetImage(getIcon(
                                          notificationData.notificationType,
                                          myLoading.isDark)),
                                      height: 28,
                                      color: ColorRes.colorTextLight),
                                ),
                              ),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 10),
                              height: 0.2,
                              color: ColorRes.colorTextLight),
                        ],
                      ),
                    ),
                  );
                },
              );
  }

  String getIcon(int? notificationType, bool isDark) {
    if (notificationType == 1) {
      return icNotiLike;
    }
    if (notificationType == 2) {
      return icNotiComment;
    }
    if (notificationType == 3) {
      return icNotiFollowing;
    }
    if (notificationType == 4) {
      return isDark ? icLogo : icLogoLight;
    }
    return isDark ? icLogo : icLogoLight;
  }

  void callApiForNotificationList() {
    if (!hasMoreData) {
      return;
    }
    if (notificationList.isEmpty) {
      isLoading = true;
      setState(() {});
    }
    ApiService()
        .getNotificationList(
            notificationList.length.toString(), paginationLimit.toString())
        .then(
      (value) {
        isLoading = false;
        notificationList.addAll(value.data ?? []);
        if ((value.data?.length ?? 0) < paginationLimit) {
          hasMoreData = false;
        }
        setState(() {});
      },
    );
  }
}
