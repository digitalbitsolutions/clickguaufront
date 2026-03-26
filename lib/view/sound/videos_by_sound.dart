import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/camera/camera_screen.dart';
import 'package:bubbly/view/login/login_sheet.dart';
import 'package:bubbly/view/profile/item_post.dart';
import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

class VideosBySoundScreen extends StatefulWidget {
  final Data? videoData;

  VideosBySoundScreen(this.videoData);

  @override
  _VideosBySoundScreenState createState() => _VideosBySoundScreenState();
}

class _VideosBySoundScreenState extends State<VideosBySoundScreen> {
  int? count = 0;
  bool isLoading = false;
  bool isPlay = false;
  bool isFav = true;
  ScrollController _scrollController = ScrollController();
  List<Data> postList = [];
  AudioPlayer audioPlayer = AudioPlayer();
  bool isLogin = false;

  @override
  void initState() {
    initIsFav();
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            callApiForGetPostsBySoundId();
          }
        }
      },
    );
    callApiForGetPostsBySoundId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBarCustom(title: LKey.soundVideos.tr),
          Container(
            height: 100,
            margin: EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          ConstRes.itemBaseUrl + widget.videoData!.soundImage!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 100,
                            height: 100,
                            color: ColorRes.colorTextLight,
                          ),
                        ),
                      ),
                      IconWithRoundGradient(
                        iconData: isPlay
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 35,
                        onTap: () async {
                          if (!isPlay) {
                            await audioPlayer.play(UrlSource(
                                ConstRes.itemBaseUrl +
                                    widget.videoData!.sound!));
                            audioPlayer.setReleaseMode(ReleaseMode.loop);
                            isPlay = true;
                          } else {
                            audioPlayer.release();
                            isPlay = false;
                          }
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 25,
                        child: Marquee(
                          text: widget.videoData!.soundTitle!,
                          style: TextStyle(
                              fontFamily: FontRes.fNSfUiMedium, fontSize: 22),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 50.0,
                          pauseAfterRound: Duration(seconds: 2),
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                      Text(
                        '${postList.length} ${LKey.videos.tr}',
                        style: TextStyle(
                            color: ColorRes.colorTextLight, fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          isFav = !isFav;
                          sessionManager.saveFavouriteMusic(
                              widget.videoData!.soundId.toString());
                          setState(() {});
                        },
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isFav
                                  ? [
                                      ColorRes.colorPrimary,
                                      ColorRes.colorPrimary
                                    ]
                                  : [ColorRes.colorTheme, ColorRes.colorPink],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          height: 30,
                          width: isFav ? 130 : 110,
                          duration: Duration(milliseconds: 500),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                !isFav
                                    ? Icons.bookmark_border_rounded
                                    : Icons.bookmark_rounded,
                                color: ColorRes.white,
                                size: !isFav ? 21 : 18,
                              ),
                              SizedBox(width: 5),
                              Text(
                                isFav ? LKey.unFavourite.tr : LKey.favourite.tr,
                                style: TextStyle(
                                    fontFamily: FontRes.fNSfUiBold,
                                    color: ColorRes.white),
                              ),
                              SizedBox(width: 2),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? LoaderDialog()
                : postList.isEmpty
                    ? DataNotFound()
                    : GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, childAspectRatio: 1 / 1.3),
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(left: 10, bottom: 20),
                        itemCount: postList.length,
                        itemBuilder: (context, index) {
                          return ItemPost(
                            list: postList,
                            data: postList[index],
                            soundId: widget.videoData!.soundId.toString(),
                            type: 3,
                            onTap: () async {
                              await audioPlayer.pause();
                              isPlay = !isPlay;
                              setState(() {});
                            },
                          );
                        },
                      ),
          ),
          FittedBox(
            child: Container(
              height: 45,
              margin:
                  EdgeInsets.only(bottom: AppBar().preferredSize.height / 2),
              padding: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: ColorRes.colorTheme,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: InkWell(
                onTap: () {
                  audioPlayer.pause();
                  isPlay = false;
                  setState(() {});
                  if (SessionManager.userId == -1 || !isLogin) {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return LoginSheet();
                      },
                    ).then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CameraScreen(
                            soundId: widget.videoData!.soundId.toString(),
                            soundTitle: widget.videoData!.soundTitle,
                            soundUrl: widget.videoData!.sound,
                          ),
                        ),
                      ).then((value) async {
                        await Future.delayed(Duration(seconds: 1));
                        await BubblyCamera.cameraDispose;
                      });
                    });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                            soundId: widget.videoData?.soundId.toString(),
                            soundTitle: widget.videoData?.soundTitle,
                            soundUrl: widget.videoData?.sound),
                      ),
                    ).then((value) async {
                      await Future.delayed(Duration(seconds: 1));
                      await BubblyCamera.cameraDispose;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.play_circle_filled_rounded,
                      color: ColorRes.white,
                      size: 30,
                    ),
                    SizedBox(width: 5),
                    Text(
                      LKey.useThisSound.tr,
                      style: TextStyle(
                          fontFamily: FontRes.fNSfUiSemiBold,
                          fontSize: 16,
                          color: ColorRes.white),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void callApiForGetPostsBySoundId() {
    isLoading = true;
    ApiService()
        .getPostBySoundId(postList.length.toString(),
            paginationLimit.toString(), widget.videoData?.soundId.toString())
        .then((value) {
      isLoading = false;
      postList.addAll(value.data ?? []);
      setState(() {});
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  SessionManager sessionManager = SessionManager();

  void initIsFav() async {
    await sessionManager.initPref();
    isLogin = sessionManager.getBool(KeyRes.login) ?? false;
    isFav = sessionManager
        .getFavouriteMusic()
        .contains(widget.videoData!.soundId.toString());
    setState(() {});
  }
}
