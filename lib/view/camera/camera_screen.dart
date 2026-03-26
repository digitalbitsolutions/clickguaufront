import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/sound/sound.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:bubbly/view/camera/widget/seconds_tab.dart';
import 'package:bubbly/view/dialog/confirmation_dialog.dart';
import 'package:bubbly/view/music/music_screen.dart';
import 'package:bubbly/view/preview_screen.dart';
import 'package:bubbly_camera/bubbly_camera.dart';
import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  final String? soundUrl;
  final String? soundTitle;
  final String? soundId;

  CameraScreen({this.soundUrl, this.soundTitle, this.soundId});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isFlashOn = false;
  bool isFront = false;
  bool isSelected15s = true;
  bool isMusicSelect = false;
  bool isStartRecording = false;
  bool isRecordingStaring = false;
  bool isShowPlayer = false;
  String? soundId = '';

  Timer? timer;
  double currentSecond = 0;
  double currentPercentage = 0;
  double totalSeconds = 15;

  AudioPlayer? _audioPlayer;

  SoundList? _selectedMusic;
  String? _localMusic;

  Map<String, dynamic> creationParams = <String, dynamic>{};
  FlutterVideoInfo _flutterVideoInfo = FlutterVideoInfo();
  ReceivePort _port = ReceivePort();
  ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.soundUrl != null) {
      soundId = widget.soundId;
      _bindBackgroundIsolate();
      FlutterDownloader.registerCallback(downloadCallback);
      downloadMusic();
    }
    MethodChannel(ConstRes.bubblyCamera).setMethodCallHandler((payload) async {
      print('payload : $payload');
      gotoPreviewScreen(payload.arguments.toString());
      return;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer?.release();
    _audioPlayer?.dispose();
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Platform.isAndroid
              ? AndroidView(
                  viewType: 'camera',
                  layoutDirection: TextDirection.ltr,
                  creationParams: creationParams,
                  creationParamsCodec: StandardMessageCodec(),
                )
              : UiKitView(
                  viewType: 'camera',
                  layoutDirection: TextDirection.ltr,
                  creationParams: creationParams,
                  creationParamsCodec: StandardMessageCodec(),
                ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(backgroundColor: ColorRes.white, value: currentPercentage / 100, color: ColorRes.colorPrimaryDark),
                  ),
                ),
              ),
              Visibility(
                visible: isMusicSelect,
                replacement: SizedBox(height: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    widget.soundTitle != null
                        ? '${widget.soundTitle ?? ''}'
                        : _selectedMusic != null
                            ? "${_selectedMusic?.soundTitle ?? ''}"
                            : '',
                    style: TextStyle(fontFamily: FontRes.fNSfUiSemiBold, fontSize: 15, color: ColorRes.white),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isStartRecording
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: IconWithRoundGradient(
                            size: 22,
                            iconData: Icons.close_rounded,
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (mContext) {
                                    return ConfirmationDialog(
                                      aspectRatio: 2,
                                      title1: LKey.areYouSure.tr,
                                      title2: LKey.doYouReallyWantToGoBack.tr,
                                      positiveText: LKey.yes.tr,
                                      onPositiveTap: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                          ),
                        ),
                  Spacer(),
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: IconWithRoundGradient(
                          size: 20,
                          iconData: !isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                          onTap: () async {
                            isFlashOn = !isFlashOn;
                            setState(() {});
                            await BubblyCamera.flashOnOff;
                          },
                        ),
                      ),
                      isStartRecording
                          ? SizedBox()
                          : Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: IconWithRoundGradient(
                                iconData: Icons.flip_camera_android_rounded,
                                size: 20,
                                onTap: () async {
                                  isFront = !isFront;
                                  await BubblyCamera.toggleCamera;
                                  setState(() {});
                                },
                              ),
                            ),
                      isRecordingStaring
                          ? SizedBox()
                          : Visibility(
                              visible: soundId == null || soundId!.isEmpty,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
                                    backgroundColor: ColorRes.colorPrimaryDark,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return MusicScreen(
                                        (data, localMusic) async {
                                          isMusicSelect = true;
                                          _selectedMusic = data;
                                          _localMusic = localMusic;
                                          soundId = data?.soundId.toString();
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ).then((value) {
                                    Provider.of<MyLoading>(context, listen: false).setLastSelectSoundId('');
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: ImageWithRoundGradient(icMusic, 11),
                                ),
                              ),
                            ),
                    ],
                  )
                ],
              ),
              Spacer(),
              isRecordingStaring
                  ? SizedBox()
                  : Visibility(
                      visible: !isMusicSelect,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SecondsTab(
                            onTap: () {
                              isSelected15s = true;
                              totalSeconds = 15;
                              setState(() {});
                            },
                            isSelected: isSelected15s,
                            title: AppRes.fiftySecond,
                          ),
                          SizedBox(width: 15),
                          SecondsTab(
                            onTap: () {
                              isSelected15s = false;
                              totalSeconds = 30;
                              setState(() {});
                            },
                            isSelected: !isSelected15s,
                            title: AppRes.thirtySecond,
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 5),
              SafeArea(
                top: false,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isRecordingStaring
                          ? SizedBox(
                              width: 40,
                              height: isMusicSelect ? 0 : 40,
                            )
                          : Container(
                              width: 40,
                              height: isMusicSelect ? 0 : 40,
                              child: IconWithRoundGradient(
                                iconData: Icons.image,
                                size: isMusicSelect ? 0 : 20,
                                onTap: () => _showFilePicker(),
                              ),
                            ),
                      InkWell(
                        onTap: () async {
                          isStartRecording = !isStartRecording;
                          isRecordingStaring = true;
                          setState(() {});
                          startProgress();
                        },
                        child: Container(
                          height: 85,
                          width: 85,
                          decoration: BoxDecoration(color: ColorRes.white, shape: BoxShape.circle),
                          padding: EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          child: isStartRecording
                              ? Icon(
                                  Icons.pause,
                                  color: ColorRes.colorTheme,
                                  size: 50,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: ColorRes.colorTheme,
                                    shape: isStartRecording ? BoxShape.rectangle : BoxShape.circle,
                                  ),
                                ),
                        ),
                      ),
                      Visibility(
                        visible: !isStartRecording,
                        replacement: SizedBox(height: 38, width: 38),
                        child: IconWithRoundGradient(
                          iconData: Icons.check_circle_rounded,
                          size: 20,
                          onTap: () async {
                            if (!isRecordingStaring) {
                              CommonUI.showToast(msg: LKey.videoIsToShort.tr);
                            } else {
                              if (soundId != null && soundId!.isNotEmpty && Platform.isIOS) {
                                await _stopAndMergeVideoForIos();
                              } else {
                                await BubblyCamera.stopRecording;
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) async {
      int status = data[1];

      if (status == 3) {
        Navigator.pop(context);
        _audioPlayer = AudioPlayer();
        isMusicSelect = true;
        _localMusic = _localMusic! + '/' + widget.soundUrl!;
        setState(() {});
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid ? await (getExternalStorageDirectory()) : await getApplicationDocumentsDirectory();
    return directory!.path;
  }

  void downloadMusic() async {
    _localMusic = (await _findLocalPath()) + Platform.pathSeparator + UrlRes.camera;
    final savedDir = Directory(_localMusic!);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    if (File(_localMusic! + widget.soundUrl!).existsSync()) {
      File(_localMusic! + widget.soundUrl!).deleteSync();
    }
    await FlutterDownloader.enqueue(
      url: ConstRes.itemBaseUrl + widget.soundUrl!,
      savedDir: _localMusic!,
      showNotification: false,
      openFileFromNotification: false,
    );
    CommonUI.showLoader(context);
  }

  // Recording
  void startProgress() async {
    if (timer == null) {
      initProgress();
    } else {
      if (isStartRecording) {
        initProgress();
      } else {
        cancelTimer();
      }
    }
    if (isStartRecording) {
      if (currentSecond == 0) {
        if (soundId != null && soundId!.isNotEmpty) {
          _audioPlayer = AudioPlayer(playerId: '1');
          await _audioPlayer?.play(
            DeviceFileSource(_localMusic!),
            mode: PlayerMode.mediaPlayer,
            ctx: AudioContext(
              android: AudioContextAndroid(isSpeakerphoneOn: true),
              iOS: AudioContextIOS(
                category: AVAudioSessionCategory.playAndRecord,
                options: [AVAudioSessionOptions.allowAirPlay, AVAudioSessionOptions.allowBluetooth, AVAudioSessionOptions.allowBluetoothA2DP, AVAudioSessionOptions.defaultToSpeaker],
              ),
            ),
          );
          var totalSecond = await Future.delayed(Duration(milliseconds: 300), () => _audioPlayer!.getDuration());
          totalSeconds = totalSecond!.inSeconds.toDouble();
          initProgress();
        }
        await BubblyCamera.startRecording;
      } else {
        print('Audio Resume Recording');
        await _audioPlayer?.resume();
        await BubblyCamera.resumeRecording;
      }
    } else {
      print('Audio Pause Recording');
      await _audioPlayer?.pause();
      await BubblyCamera.pauseRecording;
    }
    print('============ ${currentSecond}');
  }

  // Stop Merge For iOS
  Future<void> _stopAndMergeVideoForIos({bool isAutoStop = false}) async {
    print('_stopAndMergeVideoForIos');
    CommonUI.showLoader(context);
    if (isAutoStop) {
      await BubblyCamera.pauseRecording;
    }
    await Future.delayed(Duration(milliseconds: 500));
    await BubblyCamera.mergeAudioVideo(_localMusic ?? '');
  }

  void gotoPreviewScreen(String pathOfVideo) async {
    if (soundId != null && soundId!.isNotEmpty) {
      CommonUI.showLoader(context);
      String f = await _findLocalPath();
      if (!Platform.isAndroid) {
        FFmpegKit.execute('-i $pathOfVideo -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"').then(
          (returnCode) async {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PreviewScreen(
                  postVideo: '$pathOfVideo',
                  thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                  soundId: soundId,
                  duration: currentSecond.toInt(),
                ),
              ),
            );
          },
        );
      } else {
        if (Platform.isAndroid && isFront) {
          await FFmpegKit.execute('-i "$pathOfVideo" -y -vf hflip "$f${Platform.pathSeparator}out1.mp4"');
          FFmpegKit.execute("-i \"$f${Platform.pathSeparator}out1.mp4\" -i $_localMusic -y -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $f${Platform.pathSeparator}out.mp4").then((returnCode) {
            FFmpegKit.execute('-i $f${Platform.pathSeparator}out.mp4 -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"').then(
              (returnCode) async {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewScreen(
                      postVideo: '$f${Platform.pathSeparator}out.mp4',
                      thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                      soundId: soundId,
                      duration: currentSecond.toInt(),
                    ),
                  ),
                );
              },
            );
          });
        } else {
          FFmpegKit.execute("-i $pathOfVideo -i $_localMusic -y -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest $f${Platform.pathSeparator}out.mp4").then((returnCode) {
            FFmpegKit.execute('-i $f${Platform.pathSeparator}out.mp4 -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"').then(
              (returnCode) async {
                Navigator.pop(context);
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewScreen(
                      postVideo: '$f${Platform.pathSeparator}out.mp4',
                      thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                      soundId: soundId,
                      duration: currentSecond.toInt(),
                    ),
                  ),
                );
              },
            );
          });
        }
      }
      return;
    }
    CommonUI.showLoader(context);
    String f = await _findLocalPath();
    String soundPath = '$f${Platform.pathSeparator + DateTime.now().millisecondsSinceEpoch.toString()}sound.wav';
    await FFmpegKit.execute('-i "$pathOfVideo" -y $soundPath');
    if (Platform.isAndroid && isFront) {
      await FFmpegKit.execute('-i "$pathOfVideo" -y -vf hflip "$f${Platform.pathSeparator}out1.mp4"');
      FFmpegKit.execute('-i "$f${Platform.pathSeparator}out1.mp4" -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"').then(
        (returnCode) async {
          Navigator.pop(context);
          Navigator.pop(context);
          print(' 🛑 Recording Video 🛑');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewScreen(
                postVideo: '$f${Platform.pathSeparator}out1.mp4',
                thumbNail: '$f${Platform.pathSeparator}thumbNail.png',
                sound: soundPath,
                duration: currentSecond.toInt(),
              ),
            ),
          );
        },
      );
    } else {
      FFmpegKit.execute('-i "$pathOfVideo" -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"').then(
        (returnCode) async {
          print('Recording Video without Sound 🛑 ');
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return PreviewScreen(
                postVideo: pathOfVideo,
                thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                sound: soundPath,
                duration: currentSecond.toInt(),
              );
            }),
          );
        },
      );
    }
  }

  void _showFilePicker() async {
    HapticFeedback.mediumImpact();
    CommonUI.showLoader(context);
    _picker.pickVideo(source: ImageSource.gallery, maxDuration: Duration(minutes: 1)).then(
      (value) async {
        Navigator.pop(context);
        if (value != null && value.path.isNotEmpty) {
          VideoData? a = await (_flutterVideoInfo.getVideoInfo(value.path));
          if (a!.filesize! / 1000000 > 40) {
            showDialog(
              context: context,
              builder: (mContext) => ConfirmationDialog(
                aspectRatio: 1.8,
                title1: LKey.tooLargeVideo,
                title2: LKey.thisVideoIsGreaterThan50MbNPleaseSelectAnother.tr,
                positiveText: LKey.selectAnother.tr,
                onPositiveTap: () {
                  _showFilePicker();

                  Navigator.pop(context);
                },
              ),
            );
            return;
          }
          if ((a.duration! / 1000) > 180) {
            showDialog(
                context: context,
                builder: (mContext) {
                  return ConfirmationDialog(
                    aspectRatio: 1.8,
                    title1: LKey.tooLongVideo.tr,
                    title2: LKey.thisVideoIsGreaterThan1MinNPleaseSelectAnother.tr,
                    positiveText: LKey.selectAnother,
                    onPositiveTap: () {
                      Navigator.pop(context);
                      _showFilePicker();
                    },
                  );
                });
            return;
          }
          CommonUI.showLoader(context);
          String f = await _findLocalPath();
          await FFmpegKit.execute('-i "${value.path}" -y $f${Platform.pathSeparator}sound.wav');
          FFmpegKit.execute('-i "${value.path}" -y -ss 00:00:01.000 -vframes 1 "$f${Platform.pathSeparator}thumbNail.png"').then(
            (returnCode) async {
              Navigator.pop(context);
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewScreen(
                    postVideo: value.path,
                    thumbNail: "$f${Platform.pathSeparator}thumbNail.png",
                    sound: "$f${Platform.pathSeparator}sound.wav",
                    duration: (a.duration ?? 0) ~/ 1000,
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  void initProgress() {
    timer?.cancel();
    timer = null;

    timer = Timer.periodic(Duration(milliseconds: 10), (time) async {
      currentSecond += 0.01;
      currentPercentage = (100 * currentSecond) / totalSeconds;
      if (totalSeconds.toInt() <= currentSecond.toInt()) {
        timer?.cancel();
        timer = null;
        if (soundId != null && soundId!.isNotEmpty && Platform.isIOS) {
          _stopAndMergeVideoForIos(isAutoStop: true);
        } else {
          await BubblyCamera.stopRecording;
        }
      }
      setState(() {});
    });
  }

  void cancelTimer() {
    timer?.cancel();
    timer = null;
  }
}

class IconWithRoundGradient extends StatelessWidget {
  final IconData iconData;
  final double size;
  final Function? onTap;

  IconWithRoundGradient({required this.iconData, required this.size, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: InkWell(
        onTap: () => onTap?.call(),
        child: Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(gradient: LinearGradient(colors: [ColorRes.colorTheme, ColorRes.colorPink])),
          child: Icon(iconData, color: ColorRes.white, size: size),
        ),
      ),
    );
  }
}

class ImageWithRoundGradient extends StatelessWidget {
  final String imageData;
  final double padding;

  ImageWithRoundGradient(this.imageData, this.padding);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorRes.colorTheme,
              ColorRes.colorPink,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Image(
            image: AssetImage(imageData),
            color: ColorRes.white,
          ),
        ),
      ),
    );
  }
}
