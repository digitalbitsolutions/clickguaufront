import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/modal/live_stream/live_stream.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/firebase_res.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/view/live_stream/screen/audience_screen.dart';
import 'package:bubbly/view/live_stream/screen/broad_cast_screen.dart';
import 'package:bubbly/view/live_stream/widget/live_stream_end_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LiveStreamScreenViewModel extends BaseViewModel {
  SessionManager pref = SessionManager();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<LiveStreamUser> liveUsers = [];
  StreamSubscription<QuerySnapshot<LiveStreamUser>>? userStream;
  List<String> joinedUser = [];
  User? registrationUser;

  SettingData? settingData;

  void init() {
    prefData();
  }

  void prefData() async {
    await pref.initPref();
    registrationUser = pref.getUser();
    settingData = pref.getSetting()?.data;
    getLiveStreamUser();
  }

  void goLiveTap(BuildContext context) async {
    CommonUI.showLoader(context);
    await ApiService()
        .generateAgoraToken(registrationUser?.data?.identity)
        .then((value) async {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => BroadCastScreen(
              registrationUser: registrationUser,
              agoraToken: value.token,
              channelName: registrationUser?.data?.identity),
        ),
      );
    });
  }

  void getLiveStreamUser() {
    userStream = db
        .collection(FirebaseRes.liveStreamUser)
        .withConverter(
          fromFirestore: LiveStreamUser.fromFireStore,
          toFirestore: (LiveStreamUser value, options) {
            return value.toFireStore();
          },
        )
        .snapshots()
        .listen((event) {
      liveUsers = [];
      for (int i = 0; i < event.docs.length; i++) {
        liveUsers.add(event.docs[i].data());
      }
      notifyListeners();
    });
  }

  void onImageTap(BuildContext context, LiveStreamUser user) async {
    String authString = '${ConstRes.customerId}:${ConstRes.customerSecret}';
    String authToken = base64.encode(authString.codeUnits);
    CommonUI.showLoader(context);

    ApiService()
        .agoraListStreamingCheck(
            user.hostIdentity ?? '', authToken, '${settingData?.agoraAppId}')
        .then((value) {
      log(value.data!.toJson().toString());
      Navigator.pop(context);
      if (value.message != null) {
        return CommonUI.showToast(msg: value.message ?? '');
      }
      if (value.data?.channelExist == true ||
          value.data!.broadcasters!.isNotEmpty) {
        joinedUser.add(registrationUser?.data?.identity ?? '');
        db
            .collection(FirebaseRes.liveStreamUser)
            .doc(user.hostIdentity)
            .update({
          FirebaseRes.watchingCount: user.watchingCount! + 1,
          FirebaseRes.joinedUser: FieldValue.arrayUnion(joinedUser),
        }).then((value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AudienceScreen(
                channelName: user.hostIdentity,
                agoraToken: user.agoraToken,
                user: user,
              ),
            ),
          );
        });
      } else {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (c) {
            return LiveStreamEndSheet(
              name: user.fullName ?? '',
              onExitBtn: () async {
                Navigator.pop(context);
                db
                    .collection(FirebaseRes.liveStreamUser)
                    .doc(user.hostIdentity)
                    .delete();
                final batch = db.batch();
                var collection = db
                    .collection(FirebaseRes.liveStreamUser)
                    .doc(user.hostIdentity)
                    .collection(FirebaseRes.comment);
                var snapshots = await collection.get();
                for (var doc in snapshots.docs) {
                  batch.delete(doc.reference);
                }
                await batch.commit();
              },
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    userStream?.cancel();
    super.dispose();
  }
}
