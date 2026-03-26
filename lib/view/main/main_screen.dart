import 'dart:async';
import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/main.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:bubbly/view/camera/camera_screen.dart';
import 'package:bubbly/view/explore/explore_screen.dart';
import 'package:bubbly/view/home/home_screen.dart';
import 'package:bubbly/view/login/login_sheet.dart';
import 'package:bubbly/view/main/widget/end_user_license_agreement.dart';
import 'package:bubbly/view/notification/notifiation_screen.dart';
import 'package:bubbly/view/profile/profile_screen.dart';
import 'package:bubbly/view/video/video_list_screen.dart';
import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> mListOfWidget = [
    HomeScreen(),
    ExploreScreen(),
    NotificationScreen(),
    ProfileScreen(
      type: 0,
      userId: SessionManager.userId.toString(),
    ),
  ];

  SessionManager _sessionManager = SessionManager();
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    initPref();
    initBranchIO();
  }

  void initBranchIO() {
    FlutterBranchSdk.initSession().listen(
      (data) {
        if (data.containsKey("+clicked_branch_link") &&
            data["+clicked_branch_link"] == true) {
          if (data[UrlRes.postId] != null) {
            String postId = '${data[UrlRes.postId]}';
            ApiService().getPostByPostId(postId).then((value) {
              List<Data> list = List<Data>.generate(
                1,
                (index) {
                  return Data.fromJson(
                    value.data?.toJson(),
                  );
                },
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return VideoListScreen(
                    list: list,
                    index: 0,
                    type: 6,
                  );
                }),
              );
            });
          } else if (data[UrlRes.userId] != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  type: 1,
                  userId: data[UrlRes.userId],
                ),
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer<MyLoading>(
        builder: (context, myLoading, child) {
          return BottomNavigationBar(
            backgroundColor:
                myLoading.isDark ? ColorRes.colorPrimaryDark : ColorRes.white,
            selectedItemColor: ColorRes.colorIcon,
            unselectedItemColor: ColorRes.colorTextLight,
            type: BottomNavigationBarType.fixed,
            onTap: (value) async {
              myLoading.setSelectedItem(value);
              isLogin = sessionManager.getBool(KeyRes.login) ?? false;
              if (value >= 2 && SessionManager.userId == -1 || !isLogin) {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20))),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return LoginSheet();
                  },
                ).then((value) {
                  myLoading.setSelectedItem(0);
                });
              } else {
                if (value == 2) {
                  PermissionStatus status = await Permission.camera.request();
                  if (Platform.isAndroid && status.isGranted) {
                    PermissionStatus micro =
                        await Permission.microphone.request();
                    if (micro.isGranted) {
                      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
                      AndroidDeviceInfo androidInfo =
                          await deviceInfo.androidInfo;
                      if (androidInfo.version.sdkInt >= 33) {
                        PermissionStatus photo =
                            await Permission.photos.request();
                        PermissionStatus video =
                            await Permission.videos.request();
                        if (photo.isGranted == true &&
                            video.isGranted == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return CameraScreen();
                            }),
                          ).then((value) async {
                            _afterCameraScreenOff();
                          });
                        }
                      } else {
                        PermissionStatus status =
                            await Permission.storage.request();
                        if (status.isGranted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraScreen(),
                            ),
                          ).then((value) async {
                            _afterCameraScreenOff();
                          });
                        }
                      }
                    }
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(),
                      ),
                    ).then((value) async {
                      _afterCameraScreenOff();
                    });
                  }
                }
              }
            },
            selectedLabelStyle: TextStyle(
                fontFamily: FontRes.fNSfUiLight,
                color: ColorRes.colorIcon,
                height: 1.5,
                fontSize: 11),
            unselectedLabelStyle: TextStyle(
                fontFamily: FontRes.fNSfUiLight, height: 1.5, fontSize: 11),
            showUnselectedLabels: true,
            showSelectedLabels: true,
            currentIndex: myLoading.getSelectedItem,
            items: [
              BottomNavigationBarItem(
                  icon: Image(
                      height: 22,
                      width: 22,
                      image: AssetImage(icHome),
                      color: myLoading.getSelectedItem == 0
                          ? ColorRes.colorIcon
                          : ColorRes.colorTextLight),
                  label: LKey.home.tr),
              BottomNavigationBarItem(
                  icon: Image(
                      height: 22,
                      width: 22,
                      image: AssetImage(icExplore),
                      color: myLoading.getSelectedItem == 1
                          ? ColorRes.colorIcon
                          : ColorRes.colorTextLight),
                  label: LKey.explore.tr),
              BottomNavigationBarItem(
                  icon: Container(
                    height: 25,
                    width: 25,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [ColorRes.colorTheme, ColorRes.colorPink]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add_rounded,
                        color: ColorRes.white, size: 25),
                  ),
                  label: LKey.create.tr),
              BottomNavigationBarItem(
                  icon: Image(
                      height: 22,
                      width: 22,
                      image: AssetImage(icNotification),
                      color: myLoading.getSelectedItem == 3
                          ? ColorRes.colorIcon
                          : ColorRes.colorTextLight),
                  label: LKey.notification.tr),
              BottomNavigationBarItem(
                  icon: Image(
                      height: 22,
                      width: 22,
                      image: AssetImage(icUser),
                      color: myLoading.getSelectedItem == 4
                          ? ColorRes.colorIcon
                          : ColorRes.colorTextLight),
                  label: LKey.profile.tr),
            ],
          );
        },
      ),
      body: Consumer<MyLoading>(
        builder: (context, value, child) {
          return mListOfWidget[value.getSelectedItem >= 2
              ? value.getSelectedItem - 1
              : value.getSelectedItem];
        },
      ),
    );
  }

  void initPref() async {
    await _sessionManager.initPref();
    isLogin = _sessionManager.getBool(KeyRes.login) ?? false;
    if (Platform.isIOS && !_sessionManager.getBool(KeyRes.isAccepted)!) {
      Timer(
        Duration(seconds: 1),
        () {
          Get.bottomSheet(
            EndUserLicenseAgreement(sessionManager: _sessionManager),
            isScrollControlled: true,
            isDismissible: false,
            backgroundColor: Colors.transparent,
            enableDrag: false,
          );
        },
      );
    }
  }

  void _afterCameraScreenOff() async {
    Provider.of<MyLoading>(context, listen: false).setSelectedItem(1);
    await Future.delayed(Duration(seconds: 1));
    await BubblyCamera.cameraDispose;
  }
}
