import 'dart:developer';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:bubbly/view/video/item_video.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ForYouScreen extends StatefulWidget {
  @override
  _ForYouScreenState createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen>
    with AutomaticKeepAliveClientMixin {
  List<Data> mList = [];
  PageController pageController = PageController();
  int focusedIndex = 0;
  Map<int, VideoPlayerController> controllers = {};
  bool isLoading = false;
  bool isApiCall = true;

  @override
  void initState() {
    callApiForYou(
      (p0) {
        initVideoPlayer();
      },
    );
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isApiCall
        ? LoaderDialog()
        : mList.isEmpty
            ? DataNotFound()
            : PageView.builder(
                controller: pageController,
                itemCount: mList.length,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  Data data = mList[index];
                  return ItemVideo(
                      videoData: data,
                      videoPlayerController: controllers[index]);
                },
              );
  }

  void callApiForYou(Function(List<Data>) onCompletion) {
    isLoading = true;
    if (isApiCall) {
      isApiCall = true;
    }
    ApiService()
        .getPostList(paginationLimit.toString(),
            SessionManager.userId.toString(), UrlRes.related)
        .then(
      (value) {
        isLoading = false;
        isApiCall = false;

        if (value.data != null && (value.data ?? []).isNotEmpty) {
          if (mList.isEmpty) {
            mList = value.data ?? [];
          } else {
            mList.addAll(value.data ?? []);
          }
          onCompletion(mList);
        }
        setState(() {});
      },
    );
  }

  void pausePlayer() async {
    await controllers[focusedIndex]?.pause();
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

      await controller.initialize();
      if (this.mounted) {
        /// Initialize
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
        log('🚀🚀🚀 PLAYING $index');
        ApiService().increasePostViewCount(mList[index].postId.toString());
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

        /// Reset postiton to beginning
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
    pageController.dispose();
    super.dispose();
    controllers.forEach((key, value) async {
      await value.dispose();
    });
  }
}
