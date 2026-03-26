import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/key_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/theme.dart';
import 'package:bubbly/view/chat_screen/chat_screen.dart';
import 'package:bubbly/view/main/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'api/api_service.dart';

SessionManager sessionManager = SessionManager();
String selectedLanguage = byDefaultLanguage;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(ignoreSsl: true);
  await sessionManager.initPref();
  await _initAppTrackingTransparency();
  selectedLanguage = sessionManager.giveString(KeyRes.languageCode) ?? byDefaultLanguage;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyLoading>(
      create: (context) => MyLoading(),
      child: Consumer<MyLoading>(
        builder: (context, MyLoading myLoading, child) {
          // print('Mode : ${myLoading.isDark}');
          SystemChrome.setSystemUIOverlayStyle(
            myLoading.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          );
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: MyBehavior(),
                child: child!,
              );
            },
            translations: LanguagesKeys(),
            locale: Locale(selectedLanguage),
            fallbackLocale: const Locale(byDefaultLanguage),
            theme: myLoading.isDark ? darkTheme(context) : lightTheme(context),
            home: MyBubblyApp(),
          );
        },
      ),
    );
  }
}

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> _initAppTrackingTransparency() async {
  final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  // If the system can show an authorization request dialog
  if (status == TrackingStatus.notDetermined) {
    // Request system's tracking authorization dialog
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
  await AppTrackingTransparency.getAdvertisingIdentifier();
}

class MyBubblyApp extends StatefulWidget {
  @override
  _MyBubblyAppState createState() => _MyBubblyAppState();
}

class _MyBubblyAppState extends State<MyBubblyApp> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  SessionManager _sessionManager = SessionManager();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _saveTokenUpdate();
    _getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => Scaffold(
        body: Stack(
          children: [
            Center(
              child: Image(
                width: 225,
                image: AssetImage(myLoading.isDark ? icLogoHorizontal : icLogoHorizontalLight),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 50),
                child: Text(
                  companyName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: FontRes.fNSfUiLight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveTokenUpdate() async {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions();

    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'bubbly', // id
        'Notification', // title
        playSound: true,
        enableLights: true,
        enableVibration: true,
        importance: Importance.max);

    FirebaseMessaging.onMessage.listen((message) {
      var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

      var initializationSettingsIOS = const DarwinInitializationSettings();

      var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

      flutterLocalNotificationsPlugin.initialize(initializationSettings);
      RemoteNotification? notification = message.notification;
      if (message.data['NotificationID'] == ChatScreen.notificationID) {
        return;
      }
      flutterLocalNotificationsPlugin.show(
        1,
        notification?.title,
        notification?.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: true),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
          ),
        ),
      );
    });

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  void _getUserData() async {
    String? token = await firebaseMessaging.getToken();

    await _sessionManager.initPref();

    _sessionManager.saveString(KeyRes.deviceToken, token);

    if (_sessionManager.getUser() != null && _sessionManager.getUser()!.data != null) {
      SessionManager.userId = _sessionManager.getUser()!.data!.userId ?? -1;
      SessionManager.accessToken = _sessionManager.getUser()?.data?.token ?? '';
    }
    await ApiService().fetchSettingsData();

    Provider.of<MyLoading>(context, listen: false).setUser(_sessionManager.getUser());
    !ConstRes.isDialog ? SizedBox() : Provider.of<MyLoading>(context, listen: false).setIsHomeDialogOpen(true);
    Provider.of<MyLoading>(context, listen: false).setSelectedItem(0);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (route) => false);
  }
}

// Overscroll color remove
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
