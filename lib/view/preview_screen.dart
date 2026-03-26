import 'dart:io';
import 'dart:math';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/nudity/nudity_checker.dart';
import 'package:bubbly/modal/nudity/nudity_media_id.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/main/main_screen.dart';
import 'package:bubbly/view/upload/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PreviewScreen extends StatefulWidget {
  final String? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;
  final int duration;

  PreviewScreen({this.postVideo, this.thumbNail, this.sound, this.soundId, required this.duration});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  VideoPlayerController? _videoPlayerController;
  SessionManager sessionManager = SessionManager();

  SettingData? settingData;
  String mediaId = '';

  @override
  void initState() {
    prefData();
    initPlayVideo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: InkWell(
        onTap: () {
          if (_videoPlayerController!.value.isPlaying) {
            _videoPlayerController?.pause();
          } else {
            _videoPlayerController?.play();
          }
          setState(() {});
        },
        child: Column(
          children: [
            AppBarCustom(title: LKey.preview.tr),
            Container(height: 0.3, color: ColorRes.colorTextLight, margin: EdgeInsets.only(bottom: 0)),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(aspectRatio: _videoPlayerController?.value.aspectRatio ?? 2 / 3, child: VideoPlayer(_videoPlayerController!)),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: onCheckButtonClick,
                      child: Container(
                          height: 50,
                          width: 50,
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: ColorRes.colorTheme),
                          child: Icon(Icons.check_rounded, color: ColorRes.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCheckButtonClick() async {
    print(settingData?.isContentModeration);
    if (settingData?.isContentModeration == 1) {
      checkVideoModeration();
    } else {
      navigateScreen();
    }
  }

  void checkVideoModeration() async {
    CommonUI.showLoader(context);
    NudityMediaId nudityMediaId = await ApiService()
        .checkVideoModerationApiMoreThenOneMinutes(apiUser: settingData?.sightEngineApiUser ?? '', apiSecret: settingData?.sightEngineApiSecret ?? '', file: File(widget.postVideo ?? ''));
    Navigator.pop(context);

    await Future.delayed(Duration.zero);

    if (nudityMediaId.status == 'success') {
      mediaId = nudityMediaId.media?.id ?? '';
      getVideoModerationChecker();
    } else {
      print('object Dhruv Kathiriya');
      CommonUI.showToast(msg: nudityMediaId.error?.message ?? '', backGroundColor: ColorRes.red, duration: 2);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
    }
  }

  void navigateScreen() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      builder: (context) {
        return UploadScreen(postVideo: widget.postVideo, thumbNail: widget.thumbNail, soundId: widget.soundId, sound: widget.sound);
      },
    );
  }

  void prefData() async {
    await sessionManager.initPref();
    settingData = sessionManager.getSetting()?.data;
    setState(() {});
  }

  void initPlayVideo() {
    print('File Path : ${widget.postVideo}');
    _videoPlayerController = VideoPlayerController.file(File(widget.postVideo!))
      ..initialize().then((_) {
        _videoPlayerController?.play();
        setState(() {});
        _videoPlayerController?.setLooping(true);
      });
  }

  void getVideoModerationChecker() async {
    List<double> nudityList = [];
    if (Get.isDialogOpen == false) {
      Get.dialog(LoaderDialog());
    }

    NudityChecker nudityChecker = await ApiService().getOnGoingVideoJob(mediaId: mediaId, apiUser: settingData?.sightEngineApiUser ?? '', apiSecret: settingData?.sightEngineApiSecret ?? '');

    if (nudityChecker.status == 'failure') {
      Get.back();
      CommonUI.showToast(msg: nudityChecker.error?.message ?? '', backGroundColor: ColorRes.red, duration: 2);
    }

    if (nudityChecker.output?.data?.status == 'ongoing') {
      getVideoModerationChecker();
      return;
    }
    Get.back();

    if (nudityChecker.output?.data?.status == 'finished') {
      nudityChecker.output?.data?.frames?.forEach((element) {
        nudityList.add(element.nudity?.raw ?? 0.0);
        nudityList.add(element.weapon ?? 0.0);
        nudityList.add(element.alcohol ?? 0.0);
        nudityList.add(element.drugs ?? 0.0);
        nudityList.add(element.medicalDrugs ?? 0.0);
        nudityList.add(element.recreationalDrugs ?? 0.0);
        nudityList.add(element.weaponFirearm ?? 0.0);
        nudityList.add(element.weaponKnife ?? 0.0);
      });
      print(nudityList);
      if (nudityList.reduce(max) > 0.7) {
        CommonUI.showToast(msg: "This media contains sensitive content which is not allowed to post on the platform!", duration: 2, backGroundColor: ColorRes.red);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
            (route) => false);
      } else {
        navigateScreen();
      }
    }

    if (nudityChecker.output?.data?.status == 'failure') {
      CommonUI.showToast(msg: nudityChecker.error?.message ?? '', duration: 2, backGroundColor: ColorRes.red);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
          (route) => false);
    }
  }

  @override
  void dispose() {
    print('Dispose');
    _videoPlayerController!.dispose();
    _videoPlayerController = null;
    super.dispose();
  }
}
