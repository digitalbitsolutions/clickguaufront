import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/data_not_found.dart';
import 'package:bubbly/modal/followers/follower_following_data.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/view/profile/profile_screen.dart';
import 'package:flutter/material.dart';

import 'item_follower.dart';

class ItemFollowersPage extends StatefulWidget {
  final int? userId;
  final int type;

  ItemFollowersPage(this.userId, this.type);

  @override
  _ItemFollowersPageState createState() => _ItemFollowersPageState();
}

class _ItemFollowersPageState extends State<ItemFollowersPage>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  List<FollowerUserData> userList = [];
  bool isLoading = true;

  @override
  void initState() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            callApiForFollowerOrFollowing();
          }
        }
      },
    );
    callApiForFollowerOrFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return userList.isEmpty
        ? DataNotFound()
        : ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        type: 1,
                        userId: widget.type == 0
                            ? "${userList[index].fromUserId ?? -1}"
                            : "${userList[index].toUserId ?? -1}",
                      ),
                    ),
                  );
                },
                child: ItemFollowers(userList[index]),
              );
            },
            itemCount: userList.length,
            controller: _scrollController,
            padding: EdgeInsets.zero,
          );
  }

  void callApiForFollowerOrFollowing() {
    isLoading = true;
    ApiService()
        .getFollowersList(widget.userId.toString(), userList.length.toString(),
            paginationLimit.toString(), widget.type)
        .then((value) {
      isLoading = false;
      userList.addAll(value.data ?? []);
      setState(() {});
    });
  }

  @override
  bool get wantKeepAlive => true;
}
