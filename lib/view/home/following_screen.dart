import 'dart:developer';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:bubbly/view/home/widget/item_following.dart';
import 'package:bubbly/view/video/item_video.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class FollowingScreen extends StatefulWidget {
  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen>
    with AutomaticKeepAliveClientMixin {
  List<Data> mList = [];
  PageController pageController = PageController();
  bool isFollowingDataEmpty = false;
  int limit = 10;
  int focusedIndex = 0;
  Map<int, VideoPlayerController> controllers = {};
  bool isLoading = false;
  bool _isLoadingFirstTime = true;

  @override
  void initState() {
    callApiFollowing((p0) {
      initVideoPlayer();
    }, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer(
      builder: (context, MyLoading myLoading, child) => _isLoadingFirstTime
          ? LoaderDialog()
          : isFollowingDataEmpty
              ? mList.isEmpty
                  ? DataNotFound()
                  : Column(
                      children: [
                        SizedBox(height: AppBar().preferredSize.height * 2),
                        Image(
                          width: 60,
                          image: AssetImage(
                              myLoading.isDark ? icLogo : icLogoLight),
                        ),
                        SizedBox(height: 10),
                        Text(
                          LKey.popularCreator.tr,
                          style: TextStyle(
                              fontSize: 18, fontFamily: FontRes.fNSfUiSemiBold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          LKey.followSomeCreatorsTonWatchTheirVideos.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: ColorRes.colorTextLight,
                            fontFamily: FontRes.fNSfUiRegular,
                          ),
                        ),
                        Expanded(
                          child: CarouselSlider.builder(
                            itemCount: mList.length,
                            options: CarouselOptions(
                              enlargeCenterPage: true,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.7,
                              aspectRatio: 1,
                              onPageChanged: (index, reason) {
                                onPageChanged(index);
                              },
                            ),
                            itemBuilder: (context, index, realIndex) {
                              return ItemFollowing(
                                  mList[index], controllers[index]);
                            },
                          ),
                        ),
                      ],
                    )
              : mList.isEmpty
                  ? DataNotFound()
                  : PageView.builder(
                      itemCount: mList.length,
                      controller: pageController,
                      pageSnapping: true,
                      onPageChanged: onPageChanged,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return ItemVideo(
                            videoData: mList[index],
                            videoPlayerController: controllers[index]);
                      },
                    ),
    );
  }

  void callApiFollowing(Function(List<Data>) onCompletion, bool isCallForYou) {
    isLoading = true;
    if (_isLoadingFirstTime) {
      _isLoadingFirstTime = true;
      setState(() {});
    }
    ApiService()
        .getPostList(paginationLimit.toString(),
            SessionManager.userId.toString(), UrlRes.following)
        .then(
      (value) {
        isLoading = false;
        _isLoadingFirstTime = false;
        setState(() {});
        if (value.data != null && value.data!.isNotEmpty) {
          if (mList.isEmpty) {
            mList = value.data ?? [];
            setState(() {});
          } else {
            mList.addAll(value.data ?? []);
          }
          onCompletion(mList);
        } else {
          if (isCallForYou) {
            isFollowingDataEmpty = true;
            callApiForYou(
              (p0) {
                initVideoPlayer();
              },
            );
          }
        }
      },
    );
  }

  void callApiForYou(Function(List<Data>) onCompletion) {
    isLoading = true;
    ApiService().getPostList(limit.toString(), "2", UrlRes.trending).then(
      (value) {
        isLoading = false;
        if (value.data != null && value.data!.isNotEmpty) {
          if (mList.isEmpty) {
            mList = value.data ?? [];
            setState(() {});
          } else {
            mList.addAll(value.data ?? []);
          }
          onCompletion(mList);
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
      controller.initialize();
      if (this.mounted) {
        print('=======object');
        setState(() {});
      }

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
        setState(() {});
        log('🚀🚀🚀 PLAYING $index');
        ApiService().increasePostViewCount(mList[index].postId.toString());
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
    await _initializeControllerAtIndex(0);

    /// Play 1st video
    _playControllerAtIndex(0);

    /// Initialize 2nd vide
    await _initializeControllerAtIndex(1);
  }

  void onPageChanged(int value) {
    if (value == mList.length - 3) {
      if (!isLoading) {
        if (!isFollowingDataEmpty) {
          callApiFollowing((p0) {}, false);
        } else {
          callApiForYou(
            (p0) {},
          );
        }
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
    pageController.dispose();
    super.dispose();
    controllers.forEach((key, value) async {
      await value.dispose();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
