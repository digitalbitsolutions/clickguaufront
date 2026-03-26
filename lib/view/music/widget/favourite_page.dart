import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/modal/sound/sound.dart';
import 'package:bubbly/view/music/widget/music_card.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  final Function? onClick;

  FavouritePage({this.onClick});

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<SoundList> favMusicList = [];

  @override
  void initState() {
    getFavouriteSoundList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 5),
      itemCount: favMusicList.length,
      itemBuilder: (context, index) {
        return MusicCard(
          soundList: favMusicList[index],
          onItemClick: (sound) {
            widget.onClick!(sound);
          },
          onFavouriteCall: () {
            favMusicList.remove(favMusicList[index]);
            setState(() {});
          },
          type: 2,
        );
      },
    );
  }

  void getFavouriteSoundList() {
    ApiService().getFavouriteSoundList().then((value) {
      favMusicList = value.data ?? [];
      setState(() {});
    });
  }
}
