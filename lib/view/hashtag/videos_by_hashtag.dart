import 'dart:async';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/search/widget/item_search_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class VideosByHashTagScreen extends StatefulWidget {
  final String? hashTag;

  VideosByHashTagScreen(this.hashTag);

  @override
  _VideosByHashTagScreenState createState() => _VideosByHashTagScreenState();
}

class _VideosByHashTagScreenState extends State<VideosByHashTagScreen> {
  var start = 0;
  int? count = 0;

  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  final StreamController _streamController = StreamController<List<Data>?>();
  List<Data> postList = [];

  @override
  void initState() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            callApiForGetPostsByHashTag();
          }
        }
      },
    );
    callApiForGetPostsByHashTag();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Scaffold(
        body: Column(
          children: [
            AppBarCustom(title: widget.hashTag ?? ''),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 15,
              ),
              height: 80,
              decoration: BoxDecoration(
                color: myLoading.isDark
                    ? ColorRes.colorPrimary
                    : ColorRes.greyShade100,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Row(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ColorRes.colorTheme,
                          ColorRes.colorPink,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        AppRes.hashTag,
                        style: TextStyle(
                            fontFamily: FontRes.fNSfUiBold,
                            fontSize: 45,
                            color: ColorRes.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hashTag ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: FontRes.fNSfUiBold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '$count ${LKey.videos.tr}',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorRes.colorTextLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  List<Data>? userVideo = [];
                  if (snapshot.data != null) {
                    userVideo = (snapshot.data as List<Data>?)!;
                    postList.addAll(userVideo);
                    _streamController.add(null);
                  }
                  print(postList.length);
                  return postList.isEmpty
                      ? DataNotFound()
                      : GridView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.4,
                          ),
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(left: 10, bottom: 20),
                          itemCount: postList.length,
                          itemBuilder: (context, index) {
                            return ItemSearchVideo(
                              videoData: postList[index],
                              postList: postList,
                              type: 4,
                              hashTag: widget.hashTag,
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void callApiForGetPostsByHashTag() {
    ApiService()
        .getPostByHashTag(
      start.toString(),
      paginationLimit.toString(),
      widget.hashTag!.replaceAll(AppRes.hashTag, ''),
    )
        .then(
      (value) {
        start += paginationLimit;
        isLoading = false;
        if (count == 0) {
          count = value.totalVideos;
          setState(() {});
        }
        _streamController.add(value.data);
      },
    );
  }
}
