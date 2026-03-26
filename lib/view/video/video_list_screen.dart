import 'dart:developer';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/login/login_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'item_video.dart';

class VideoListScreen extends StatefulWidget {
  final List<Data> list;
  final int index;
  final int? type;
  final String? userId;
  final String? soundId;
  final String? hashTag;
  final String? keyWord;

  VideoListScreen({
    required this.list,
    required this.index,
    required this.type,
    this.userId,
    this.soundId,
    this.hashTag,
    this.keyWord,
  });

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  List<Data> mList = [];
  PageController _pageController = PageController();
  int startingPositionIndex = 0;
  int position = 0;

  TextEditingController _commentController = TextEditingController();
  SessionManager sessionManager = SessionManager();
  bool isLogin = false;

  int focusedIndex = 0;
  Map<int, VideoPlayerController> controllers = {};
  bool isLoading = false;

  FocusNode commentFocusNode = FocusNode();

  @override
  void initState() {
    prefData();
    mList = widget.list;
    _pageController = PageController(initialPage: widget.index);
    startingPositionIndex = widget.list.length;
    position = widget.index;
    initVideoPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                    controller: _pageController,
                    physics: ClampingScrollPhysics(),
                    pageSnapping: true,
                    onPageChanged: onPageChanged,
                    scrollDirection: Axis.vertical,
                    itemCount: mList.length,
                    itemBuilder: (context, index) {
                      return ItemVideo(
                          videoData: mList[index],
                          videoPlayerController: controllers[index]);
                    }),
              ),
              SafeArea(
                top: false,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            controller: _commentController,
                            focusNode: commentFocusNode,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: LKey.leaveYourComment.tr,
                                hintStyle: TextStyle(
                                    fontFamily: FontRes.fNSfUiRegular),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 10)),
                            cursorColor: ColorRes.colorTextLight),
                      ),
                      ClipOval(
                        child: InkWell(
                          onTap: () {
                            if (_commentController.text.trim().isEmpty) {
                              CommonUI.showToast(
                                  msg: LKey.enterCommentFirst.tr);
                            } else {
                              if (SessionManager.userId == -1 || !isLogin) {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return LoginSheet();
                                  },
                                );
                                return;
                              }

                              ApiService()
                                  .addComment(_commentController.text.trim(),
                                      '${mList[position].postId}')
                                  .then(
                                (value) {
                                  _commentController.clear();
                                  commentFocusNode.unfocus();
                                  mList[position].setPostCommentCount(true);
                                  setState(() {});
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                ColorRes.colorTheme,
                                ColorRes.colorPink
                              ]),
                            ),
                            child: Icon(Icons.send_rounded,
                                color: ColorRes.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            bottom: false,
            child: IconButton(
              icon: Icon(Icons.chevron_left_rounded),
              color: ColorRes.white,
              iconSize: 35,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void callApiForYou(Function(List<Data>) onCompletion) {
    ApiService()
        .getPostsByType(
      pageDataType: widget.type,
      userId: widget.userId,
      soundId: widget.soundId,
      hashTag: widget.hashTag,
      keyWord: widget.keyWord,
      start: startingPositionIndex.toString(),
      limit: paginationLimit.toString(),
    )
        .then(
      (value) {
        if (value.data != null && value.data!.isNotEmpty) {
          if (mList.isEmpty) {
            mList = value.data ?? [];
            setState(() {});
          } else {
            mList.addAll(value.data ?? []);
          }
          startingPositionIndex += paginationLimit;
        }
      },
    );
  }

  void _playNext(int index) {
    controllers.forEach((key, value) {
      if (value.value.isPlaying) {
        value.pause();
      }
    });

    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index + 1] controller

    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    controllers.forEach((key, value) {
      value.pause();
    });

    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  Future _initializeControllerAtIndex(int index) async {
    if (mList.length > index && index >= 0) {
      /// Create new controller
      final VideoPlayerController controller = VideoPlayerController.networkUrl(
          Uri.parse(ConstRes.itemBaseUrl + (mList[index].postVideo ?? '')));

      /// Add to [controllers] list
      controllers[index] = controller;

      /// Initialize
      await controller.initialize().then((value) {
        setState(() {});
      });

      log('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) {
    focusedIndex = index;
    if (mList.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController? controller = controllers[index];

      if (controller != null) {
        /// Play controller
        controller.play();
        controller.setLooping(true);
        ApiService().increasePostViewCount(mList[index].postId.toString());
        log('🚀🚀🚀 PLAYING $index');
        setState(() {});
      }
    }
  }

  void _stopControllerAtIndex(int index) {
    if (mList.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController? controller = controllers[index];

      if (controller != null) {
        /// Pause
        controller.pause();

        /// Reset position to beginning
        controller.seekTo(const Duration());
        log('==================================');
        log('🚀🚀🚀 STOPPED $index');
      }
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (mList.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController? controller = controllers[index];

      /// Dispose controller
      controller?.dispose();

      if (controller != null) {
        controllers.remove(controller);
      }

      log('🚀🚀🚀 DISPOSED $index');
    }
  }

  void initVideoPlayer() async {
    /// Initialize 1st video
    await _initializeControllerAtIndex(position);

    /// Play 1st video
    _playControllerAtIndex(position);

    /// Initialize 2nd vide
    if (position >= 0) {
      await _initializeControllerAtIndex(position - 1);
    }
    await _initializeControllerAtIndex(position + 1);
  }

  void onPageChanged(int value) {
    if (value == mList.length - 3) {
      if (!isLoading) {
        callApiForYou(
          (p0) {},
        );
      }
    }
    if (value > focusedIndex) {
      _playNext(value);
    } else {
      _playPrevious(value);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controllers.forEach((key, value) async {
        await value.dispose();
      });
    });
    _pageController.dispose();
  }

  void prefData() async {
    await sessionManager.initPref();
    isLogin = sessionManager.getBool(KeyRes.login) ?? false;
    setState(() {});
  }
}
