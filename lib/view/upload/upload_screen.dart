import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/privacy_policy_view.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/app_res.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/utils/session_manager.dart';
import 'package:bubbly/utils/url_res.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatefulWidget {
  final String? postVideo;
  final String? thumbNail;
  final String? sound;
  final String? soundId;

  UploadScreen({this.postVideo, this.thumbNail, this.sound, this.soundId});

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  ValueNotifier<int> textSize = ValueNotifier<int>(0);
  String postDes = '';
  String currentHashTag = '';
  List<String> hashTags = [];
  SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    initSessionManager();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          height: 440,
          decoration: BoxDecoration(
            color: myLoading.isDark ? ColorRes.colorPrimary : ColorRes.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(LKey.uploadVideo.tr,
                          style: TextStyle(
                              fontSize: 16, fontFamily: FontRes.fNSfUiBold)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.close_rounded),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  Divider(thickness: 1),
                  SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Image(
                          height: 160,
                          width: 110,
                          fit: BoxFit.cover,
                          image: FileImage(File(widget.thumbNail!)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LKey.describe.tr,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: myLoading.isDark
                                    ? ColorRes.colorPrimaryDark
                                    : ColorRes.greyShade100,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: EdgeInsets.only(left: 15, right: 15),
                              height: 130,
                              child: DetectableTextField(
                                decoratedStyle: TextStyle(
                                  fontFamily: FontRes.fNSfUiBold,
                                  letterSpacing: 0.6,
                                  fontSize: 13,
                                  color: ColorRes.colorTextLight,
                                ),
                                basicStyle: TextStyle(
                                  fontFamily: FontRes.fNSfUiRegular,
                                  letterSpacing: 0.6,
                                  fontSize: 13,
                                  color: ColorRes.colorTextLight,
                                ),
                                textInputAction: TextInputAction.done,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(175)
                                ],
                                enableSuggestions: false,
                                maxLines: 8,
                                onChanged: (value) {
                                  textSize.value = value.length;
                                  postDes = value;
                                },
                                onDetectionTyped: (text) {
                                  currentHashTag = text.split("#")[1];
                                },
                                onDetectionFinished: () {
                                  if (currentHashTag.isNotEmpty) {
                                    hashTags.add(currentHashTag);
                                    currentHashTag = '';
                                  }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: LKey.awesomeCaption.tr,
                                  hintStyle: TextStyle(
                                    color: ColorRes.colorTextLight,
                                  ),
                                ),
                                detectionRegExp:
                                    detectionRegExp(hashtag: true)!,
                                cursorColor: ColorRes.colorTextLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                      child: ValueListenableBuilder(
                        valueListenable: textSize,
                        builder: (context, dynamic value, child) => Text(
                          '$value/${AppRes.maxLengthText}',
                          style: TextStyle(
                            color: ColorRes.colorTextLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () {
                    if (currentHashTag.isNotEmpty) {
                      hashTags.add(currentHashTag);
                      currentHashTag = '';
                    }
                    CommonUI.showLoader(context);
                    Map<String, dynamic>? param = {};

                    param[UrlRes.duration] = '1';
                    param[UrlRes.soundId] = widget.soundId;

                    if (postDes.isNotEmpty) {
                      param[UrlRes.postDescription] = postDes;
                    }
                    if (hashTags.isNotEmpty) {
                      param[UrlRes.postHashTag] = hashTags.join(',');
                    }

                    if (widget.soundId != null) {
                      param[UrlRes.isOriginalSound] = '0';
                      ApiService()
                          .addPost(
                        postVideo: File(widget.postVideo ?? ''),
                        thumbnail: File(widget.thumbNail ?? ''),
                        duration: '1',
                        isOriginalSound: '0',
                        postDescription: postDes,
                        postHashTag: hashTags.join(","),
                        soundId: widget.soundId,
                      )
                          .then(
                        (value) {
                          if (value.status == 200) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            CommonUI.showToast(
                                msg: LKey.postUploadSuccessfully.tr);
                          } else if (value.status == 401) {
                            CommonUI.showToast(msg: "${value.message}");
                            Navigator.pop(context);
                          }
                        },
                      );
                    } else {
                      print('sound not available');
                      param[UrlRes.isOriginalSound] =
                          widget.soundId != null ? '0' : '1';
                      param[UrlRes.singer] =
                          _sessionManager.getUser()?.data?.fullName;
                      param[UrlRes.soundTitle] = 'Original Sound';

                      ApiService()
                          .addPost(
                        postVideo: File(widget.postVideo!),
                        thumbnail: File(widget.thumbNail!),
                        postSound: File(widget.sound!),
                        soundImage: File(widget.thumbNail!),
                        duration: '1',
                        isOriginalSound: widget.soundId != null ? '0' : '1',
                        postDescription: postDes,
                        postHashTag: hashTags.join(","),
                        singer: _sessionManager.getUser()?.data?.fullName,
                        soundTitle: 'Original Sound',
                        soundId: widget.soundId,
                      )
                          .then(
                        (value) {
                          Navigator.pop(context);
                          if (value.status == 200) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            CommonUI.showToast(
                                msg: LKey.postUploadSuccessfully.tr);
                          } else if (value.status == 401) {
                            CommonUI.showToast(msg: "${value.message}");
                          }
                        },
                      );
                    }
                  },
                  child: FittedBox(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            ColorRes.colorTheme,
                            ColorRes.colorPink,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Center(
                        child: Text(
                          LKey.publish.tr.toUpperCase(),
                          style: TextStyle(
                              fontFamily: FontRes.fNSfUiBold,
                              letterSpacing: 1,
                              color: ColorRes.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              PrivacyPolicyView()
            ],
          ),
        ),
      );
    });
  }

  void initSessionManager() async {
    await _sessionManager.initPref();
  }
}
