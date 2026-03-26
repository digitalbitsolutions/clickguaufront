import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/comment/comment.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/comment/widget/item_comment.dart';
import 'package:bubbly/view/login/login_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final Data? videoData;
  final Function onComment;

  CommentScreen(this.videoData, this.onComment);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  ScrollController _scrollController = ScrollController();
  TextEditingController _commentController = TextEditingController();
  FocusNode commentFocusNode = FocusNode();
  SessionManager sessionManager = SessionManager();
  bool hasNoMore = false;
  List<CommentData> commentList = [];
  bool isLogin = false;
  bool isLoading = true;

  @override
  void initState() {
    prefData();
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            callApiForComments();
          }
        }
      },
    );
    callApiForComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) {
        return Container(
          margin: EdgeInsets.only(top: AppBar().preferredSize.height),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            color:
                myLoading.isDark ? ColorRes.colorPrimaryDark : ColorRes.white,
          ),
          constraints: BoxConstraints(maxHeight: 500),
          child: Column(
            children: [
              SizedBox(height: 5),
              Stack(
                alignment: Alignment.center,
                children: [
                  Text('${commentList.length} ${LKey.comments.tr}',
                      style: TextStyle(fontSize: 16)),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              Divider(
                color: ColorRes.colorTextLight,
                thickness: 0.2,
                height: 0.2,
              ),
              SizedBox(height: 5),
              Expanded(
                child: commentList.isEmpty
                    ? DataNotFound()
                    : ListView.builder(
                        padding: EdgeInsets.only(bottom: 25),
                        controller: _scrollController,
                        itemCount: commentList.length,
                        itemBuilder: (BuildContext context, int index) {
                          CommentData commentData = commentList[index];
                          return ItemComment(
                            commentData: commentData,
                            onRemoveClick: () => _deleteCommentApi(commentData),
                          );
                        },
                      ),
              ),
              SafeArea(
                top: false,
                child: Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: myLoading.isDark
                        ? ColorRes.colorPrimary
                        : ColorRes.greyShade100,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            controller: _commentController,
                            focusNode: commentFocusNode,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: LKey.leaveYourComment.tr,
                                hintStyle:
                                    TextStyle(color: ColorRes.colorTextLight),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 15)),
                            cursorColor: ColorRes.colorTextLight),
                      ),
                      InkWell(
                        onTap: _addComment,
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                ColorRes.colorTheme,
                                ColorRes.colorPink
                              ]),
                              shape: BoxShape.circle),
                          child: Icon(Icons.send_rounded,
                              color: ColorRes.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void callApiForComments() {
    if (hasNoMore) {
      return;
    }
    isLoading = true;
    ApiService()
        .getCommentByPostId('${commentList.length}', '$paginationLimit',
            '${widget.videoData?.postId}')
        .then((value) {
      if ((value.data?.length ?? 0) < paginationLimit) {
        hasNoMore = true;
      }
      isLoading = false;
      if (commentList.isEmpty) {
        commentList.addAll(value.data ?? []);
      } else {
        for (int i = 0; i < (value.data?.length ?? 0); i++) {
          commentList.add(value.data?[i] ?? CommentData());
        }
      }
      setState(() {});
    });
  }

  void _deleteCommentApi(CommentData comment) {
    commentList.remove(comment);
    setState(() {});
    ApiService().deleteComment(comment.commentsId.toString()).then((value) {
      widget.videoData?.setPostCommentCount(false);
      widget.onComment.call();
    });
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) {
      CommonUI.showToast(msg: LKey.enterCommentFirst.tr);
    } else {
      if (SessionManager.userId == -1 || !isLogin) {
        showModalBottomSheet(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
              widget.videoData!.postId.toString())
          .then(
        (value) {
          _commentController.clear();
          commentFocusNode.unfocus();
          widget.videoData?.setPostCommentCount(true);
          widget.onComment();
          commentList = [];
          hasNoMore = false;
          callApiForComments();
        },
      );
    }
  }

  void prefData() async {
    await sessionManager.initPref();
    isLogin = sessionManager.getBool(KeyRes.login) ?? false;
    setState(() {});
  }
}
