import 'dart:async';

import 'package:flutter/services.dart';

class BubblyCamera {
  static const MethodChannel _channel = const MethodChannel('bubbly_camera');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static get showAleartDialog async {
    await _channel.invokeMethod('showAlertDialog');
  }

  static get startRecording async {
    await _channel.invokeMethod('start');
  }

  static get pauseRecording async {
    await _channel.invokeMethod('pause');
  }

  static get resumeRecording async {
    await _channel.invokeMethod('resume');
  }

  static get stopRecording async {
    await _channel.invokeMethod('stop');
  }

  static get toggleCamera async {
    await _channel.invokeMethod('toggle');
  }

  static get flashOnOff async {
    await _channel.invokeMethod('flash');
  }

  static shareToInstagram(String text) async {
    await _channel.invokeMethod('shareToInstagram', text);
  }

  static inAppPurchase(String productID) async {
    await _channel.invokeMethod('in_app_purchase_id', productID);
  }

  static saveImage(String path) async {
    await _channel.invokeMethod('path', path);
  }

  static mergeAudioVideo(String path) async {
    await _channel.invokeMethod('merge_audio_video', path);
  }

  static Future<bool> get cameraDispose async {
    return await _channel.invokeMethod('cameraDispose');
  }
}
