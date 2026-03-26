import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/sound/sound.dart';
import 'package:flutter/material.dart';

import 'item_discover.dart';

class DiscoverPage extends StatefulWidget {
  final Function? onMoreClick;
  final Function? onPlayClick;

  DiscoverPage({this.onMoreClick, this.onPlayClick});

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  List<SoundData> soundCategoryList = [];

  @override
  void initState() {
    getDiscoverSound();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: soundCategoryList.length,
      padding: EdgeInsets.only(top: 5),
      itemBuilder: (context, index) {
        return ItemDiscover(
          soundCategoryList[index],
          (soundList) {
            widget.onMoreClick?.call(soundList);
          },
          widget.onPlayClick,
        );
      },
    );
  }

  ApiService _apiService = ApiService();

  void getDiscoverSound() {
    _apiService.getSoundList().then((value) {
      soundCategoryList = value.data ?? [];
      setState(() {});
    });
  }

  @override
  void dispose() {
    _apiService.client.close();
    super.dispose();
  }
}
