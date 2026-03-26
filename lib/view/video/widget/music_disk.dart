import 'dart:math';

import 'package:bubbly/modal/user_video/user_video.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/view/sound/videos_by_sound.dart';
import 'package:flutter/material.dart';

class MusicDisk extends StatefulWidget {
  final Data? videoData;

  MusicDisk(this.videoData);

  @override
  _MusicDiskState createState() => _MusicDiskState();
}

class _MusicDiskState extends State<MusicDisk>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 5))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VideosBySoundScreen(widget.videoData)));
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi,
            child: child,
          );
        },
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(image: AssetImage(icBgDisk)),
          ),
          padding: EdgeInsets.all(10),
          child: ClipOval(
            child: Stack(
              children: [
                Center(
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorRes.colorTheme,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Image(
                        image: AssetImage(icMusic),
                        color: ColorRes.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: colorTheme,
                    ),
                    child: Image.network(
                      ConstRes.itemBaseUrl +
                          (widget.videoData!.soundImage != null
                              ? widget.videoData!.soundImage!
                              : ''),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
