import 'package:bubbly/modal/sound/sound.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicCard extends StatefulWidget {
  final SoundList soundList;
  final Function onItemClick;
  final int type;
  final Function? onFavouriteCall;

  MusicCard(
      {required this.soundList,
      required this.onItemClick,
      required this.type,
      this.onFavouriteCall});

  @override
  _MusicCardState createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  final SessionManager sessionManager = new SessionManager();

  @override
  void initState() {
    initSessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onItemClick(widget.soundList);
      },
      child: Container(
        height: 70,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consumer<MyLoading>(
              builder: (context, value, child) => Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          ConstRes.itemBaseUrl + widget.soundList.soundImage!),
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 70,
                          width: 70,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(icArtist, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: value.lastSelectSoundId ==
                        widget.soundList.sound! + '${widget.type}',
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          !value.getLastSelectSoundIsPlay
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                          color: ColorRes.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.soundList.soundTitle ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: FontRes.fNSfUiSemiBold,
                        color: ColorRes.colorTextLight),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    widget.soundList.singer ?? '',
                    style:
                        TextStyle(color: ColorRes.colorTextLight, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    widget.soundList.duration!,
                    style: TextStyle(
                      color: ColorRes.colorTextLight,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                sessionManager
                    .saveFavouriteMusic(widget.soundList.soundId.toString());
                widget.onFavouriteCall?.call();
                setState(() {});
              },
              child: Icon(
                sessionManager
                        .getFavouriteMusic()
                        .contains(widget.soundList.soundId.toString())
                    ? Icons.bookmark
                    : Icons.bookmark_border_rounded,
                color: ColorRes.colorTheme,
              ),
            ),
            Consumer<MyLoading>(
              builder: (context, value, child) => Visibility(
                visible: value.lastSelectSoundId ==
                    widget.soundList.sound! + widget.type.toString(),
                child: InkWell(
                  onTap: () async {
                    Provider.of<MyLoading>(context, listen: false)
                        .setIsDownloadClick(true);
                    widget.onItemClick(widget.soundList);
                  },
                  child: Container(
                    width: 50,
                    height: 25,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: ColorRes.colorTheme,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: ColorRes.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void initSessionManager() async {
    sessionManager.initPref().then((value) {
      setState(() {});
    });
  }
}
