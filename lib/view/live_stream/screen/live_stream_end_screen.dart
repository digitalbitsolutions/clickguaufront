import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LivestreamEndScreen extends StatefulWidget {
  const LivestreamEndScreen({Key? key}) : super(key: key);

  @override
  State<LivestreamEndScreen> createState() => _LivestreamEndScreenState();
}

class _LivestreamEndScreenState extends State<LivestreamEndScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
  SessionManager pref = SessionManager();

  String time = '';
  String watching = '';
  String diamond = '';
  String image = '';

  @override
  void initState() {
    prefData();
    super.initState();
  }

  void prefData() async {
    await pref.initPref();
    time = pref.getString(KeyRes.liveStreamingTiming) ?? '';
    watching = pref.getString(KeyRes.liveStreamWatchingUser) ?? '';
    diamond = pref.getString(KeyRes.liveStreamCollected) ?? '';
    image = pref.getString(KeyRes.liveStreamProfile) ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      '${ConstRes.itemBaseUrl}$image',
                      height: MediaQuery.of(context).size.width / 2.5,
                      width: MediaQuery.of(context).size.width / 2.5,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ImagePlaceHolder(
                          fontSize: 100,
                          heightWeight: MediaQuery.of(context).size.width / 2.5,
                          name: Provider.of<MyLoading>(context)
                                  .getUser
                                  ?.data
                                  ?.fullName ??
                              '',
                        );
                      },
                    )),
                ScaleTransition(
                  scale: _animation,
                  child: Text(
                    LKey.yourLiveStreamHasEtc.tr,
                    style:
                        TextStyle(fontFamily: FontRes.fNSfUiBold, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        SizeTransition(
                          sizeFactor: _animation,
                          axis: Axis.horizontal,
                          axisAlignment: -1,
                          child: Text('$time',
                              style: const TextStyle(
                                  fontFamily: FontRes.fNSfUiSemiBold,
                                  fontSize: 15)),
                        ),
                        Text(
                          LKey.streamFor.tr,
                          style: TextStyle(
                              fontFamily: FontRes.fNSfUiSemiBold, fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizeTransition(
                          sizeFactor: _animation,
                          axis: Axis.horizontal,
                          axisAlignment: -1,
                          child: Text('$watching',
                              style: const TextStyle(
                                  fontFamily: FontRes.fNSfUiSemiBold,
                                  fontSize: 15)),
                        ),
                        Text(
                          LKey.users.tr,
                          style: TextStyle(
                              fontFamily: FontRes.fNSfUiSemiBold, fontSize: 15),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        SizeTransition(
                          sizeFactor: _animation,
                          axis: Axis.horizontal,
                          axisAlignment: -1,
                          child: Text('$diamond',
                              style: const TextStyle(
                                  fontFamily: FontRes.fNSfUiSemiBold,
                                  fontSize: 15)),
                        ),
                        Text(
                          '💎 ${LKey.collected.tr}',
                          style: TextStyle(
                              fontFamily: FontRes.fNSfUiSemiBold, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: ColorRes.colorTheme.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          LKey.ok.tr,
                          style: TextStyle(
                              color: ColorRes.colorPink,
                              fontFamily: FontRes.fNSfUiHeavy,
                              letterSpacing: 0.8,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
