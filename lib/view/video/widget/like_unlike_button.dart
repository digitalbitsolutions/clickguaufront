import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:flutter/material.dart';

class LikeUnLikeButton extends StatefulWidget {
  final Function likeUnlike;
  final Data? videoData;

  LikeUnLikeButton({this.videoData, required this.likeUnlike});

  @override
  _LikeUnLikeButtonState createState() => _LikeUnLikeButtonState();
}

class _LikeUnLikeButtonState extends State<LikeUnLikeButton>
    with TickerProviderStateMixin {
  var squareScaleA = 1.0;
  late AnimationController _controllerA;

  @override
  void initState() {
    isLike = widget.videoData!.videoLikesOrNot == 1;
    _controllerA = AnimationController(
        vsync: this,
        lowerBound: 0.5,
        upperBound: 1.0,
        duration: Duration(milliseconds: 500));
    _controllerA.addListener(() {
      setState(() {
        squareScaleA = _controllerA.value;
      });
    });
    _controllerA.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isLike = !isLike;
        widget.likeUnlike();
        ApiService().likeUnlikePost(widget.videoData!.postId.toString());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controllerA.dispose();
    super.dispose();
  }

  bool isLike = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _controllerA.forward(from: 0.0);
      },
      child: Transform.scale(
        scale: squareScaleA,
        child: Icon(
          Icons.favorite,
          color: isLike ? Colors.red : ColorRes.white,
          size: 40,
        ),
      ),
    );
  }
}
