import 'dart:io';

import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/custom_view/app_bar_custom.dart';
import 'package:bubbly/custom_view/common_ui.dart';
import 'package:bubbly/custom_view/image_place_holder.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/profileCategory/profile_category.dart';
import 'package:bubbly/modal/status.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:bubbly/view/profile/dialog_profile_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String profileImage = '';
  String createNewUserName = '';
  String userEmail = '';
  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController faceBookController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  ImagePicker _imagePicker = ImagePicker();

  String profileCategoryID = '';
  String? profileCategoryName = '';
  UserData? user;

  @override
  void initState() {
    user = Provider.of<MyLoading>(context, listen: false).getUser?.data;
    print(user?.profileCategory);
    fullNameController = TextEditingController(text: user?.fullName ?? '');
    userNameController = TextEditingController(text: user?.userName ?? '');
    bioController = TextEditingController(text: user?.bio ?? '');
    faceBookController = TextEditingController(text: user?.fbUrl ?? '');
    youtubeController = TextEditingController(text: user?.youtubeUrl ?? '');
    instagramController = TextEditingController(text: user?.instaUrl ?? '');
    profileCategoryName =
        user?.profileCategoryName != null ? user?.profileCategoryName : '';
    profileCategoryID = "${user?.profileCategory ?? -1}";
    userEmail = user?.userEmail ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Scaffold(
        body: Column(
          children: [
            AppBarCustom(title: LKey.editProfile.tr),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: myLoading.isDark
                                  ? ColorRes.greyShade100
                                  : ColorRes.colorPrimary,
                              width: 0.5),
                          shape: BoxShape.circle),
                      child: ClipOval(
                        child: profileImage.isEmpty
                            ? Image.network(
                                ConstRes.itemBaseUrl +
                                    (myLoading.getUser?.data?.userProfile !=
                                                null &&
                                            myLoading.getUser!.data!
                                                .userProfile!.isNotEmpty
                                        ? myLoading.getUser!.data!.userProfile!
                                        : ''),
                                errorBuilder: (context, error, stackTrace) {
                                  return ImagePlaceHolder(
                                    name: user?.fullName,
                                    heightWeight: 100,
                                    fontSize: 70,
                                  );
                                },
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(profileImage),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              myLoading.isDark
                                  ? ColorRes.colorPrimary
                                  : ColorRes.greyShade100),
                          alignment: Alignment.center,
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(horizontal: 50),
                          ),
                        ),
                        onPressed: () {
                          _imagePicker
                              .pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: imageQuality,
                                  maxHeight: maxHeight,
                                  maxWidth: maxWidth)
                              .then((value) {
                            if (value != null) {
                              profileImage = value.path;
                              setState(() {});
                            } else {
                              CommonUI.showToast(
                                  msg: LKey.somethingWentWrong.tr);
                            }
                          });
                        },
                        child: Text(
                          LKey.change.tr,
                          style: TextStyle(
                            color: ColorRes.colorIcon,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      LKey.profileCategory.tr,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: myLoading.isDark
                            ? ColorRes.colorPrimary
                            : ColorRes.greyShade100,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              profileCategoryName ?? '',
                              style: TextStyle(
                                color: ColorRes.colorTextLight,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return DialogProfileCategory(
                                    function: (data) {
                                      if (data == null) {
                                        profileCategoryName = '';
                                        profileCategoryID = '-1';
                                      } else {
                                        ProfileCategoryData p = data;
                                        profileCategoryID =
                                            p.profileCategoryId.toString();
                                        profileCategoryName =
                                            p.profileCategoryName;
                                      }
                                      Navigator.pop(context);

                                      setState(() {});
                                    },
                                    categoryId: profileCategoryID,
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: ColorRes.colorIcon,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: ColorRes.greyShade100,
                                size: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      LKey.fullName.tr,
                    ),
                    TextFiledCustom(
                      controller: fullNameController,
                      hintText: LKey.fullName.tr,
                      isDarkMode: myLoading.isDark,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(height: 15),
                    Text(
                      LKey.username.tr,
                    ),
                    TextFiledCustom(
                      controller: userNameController,
                      hintText: LKey.username.tr,
                      isDarkMode: myLoading.isDark,
                      onChanged: (p0) {
                        createNewUserName = p0;
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      LKey.bio.tr,
                    ),
                    TextFiledCustom(
                      isDarkMode: myLoading.isDark,
                      controller: bioController,
                      hintText: LKey.presentYourself.tr,
                      textFieldHeight: 115,
                      isExpand: true,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      LKey.social.tr,
                    ),
                    SocialMediaTextField(
                        controller: faceBookController,
                        hintText: LKey.facebook.tr,
                        image: icFaceBook,
                        isDarkMode: myLoading.isDark),
                    SocialMediaTextField(
                        controller: instagramController,
                        hintText: LKey.instagram.tr,
                        image: icInstagram,
                        isDarkMode: myLoading.isDark),
                    SocialMediaTextField(
                        controller: youtubeController,
                        hintText: LKey.youtube.tr,
                        image: icYouTube,
                        isDarkMode: myLoading.isDark),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () => onUpdateClick(myLoading),
                      child: Center(
                        child: FittedBox(
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              gradient: LinearGradient(
                                colors: [
                                  ColorRes.colorTheme,
                                  ColorRes.colorPink,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                LKey.update.tr,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: FontRes.fNSfUiSemiBold,
                                    color: ColorRes.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void onUpdateClick(MyLoading myLoading) async {
    FocusScope.of(context).unfocus();
    if (fullNameController.text.isEmpty) {
      CommonUI.showToast(msg: LKey.fullNameRequired.tr);
      return;
    }
    if (userNameController.text.isEmpty) {
      CommonUI.showToast(msg: LKey.userNameRequired.tr);
      return;
    }

    CommonUI.showLoader(context);

    if (createNewUserName.isNotEmpty &&
        createNewUserName != userNameController.text) {
      Status s = await ApiService().checkUsername(userName: createNewUserName);
      if (s.status == 200) {
        userNameController =
            TextEditingController(text: createNewUserName.toUpperCase());
      } else {
        CommonUI.showToast(msg: s.message ?? '');
        return;
      }
    }

    ApiService()
        .updateProfile(
            fullName: fullNameController.text,
            userName:
                createNewUserName.isNotEmpty ? userNameController.text : '',
            bio: bioController.text,
            fbUrl: faceBookController.text.trim(),
            instagramUrl: instagramController.text.trim(),
            youtubeUrl: youtubeController.text.trim(),
            profileCategory: profileCategoryID,
            profileImage: profileImage.isNotEmpty ? File(profileImage) : null)
        .then(
      (value) {
        Navigator.pop(context);
        if (value.status == 200) {
          myLoading.setUser(value);
          Navigator.pop(context);
          CommonUI.showToast(msg: LKey.updateProfileSuccessfully.tr);
        } else {
          CommonUI.showToast(msg: value.message ?? '');
        }
      },
    );
  }
}

class TextFiledCustom extends StatelessWidget {
  final bool isDarkMode;
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final double textFieldHeight;
  final bool isExpand;
  final TextCapitalization textCapitalization;

  const TextFiledCustom(
      {Key? key,
      required this.isDarkMode,
      required this.controller,
      required this.hintText,
      this.onChanged,
      this.textFieldHeight = 50,
      this.isExpand = false,
      this.textCapitalization = TextCapitalization.none});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: textFieldHeight,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: isDarkMode ? ColorRes.colorPrimary : ColorRes.greyShade100,
      ),
      child: TextField(
        controller: controller,
        expands: isExpand,
        minLines: null,
        maxLines: isExpand ? null : 1,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: ColorRes.colorTextLight),
            contentPadding: EdgeInsets.symmetric(
                horizontal: 10, vertical: isExpand ? 10 : 0)),
        style: TextStyle(
          color: ColorRes.colorTextLight,
        ),
        cursorColor: ColorRes.colorTextLight,
        onChanged: onChanged,
      ),
    );
  }
}

class SocialMediaTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String image;
  final bool isDarkMode;

  const SocialMediaTextField(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.image,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: isDarkMode ? ColorRes.colorPrimary : ColorRes.greyShade100,
      ),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              color: ColorRes.colorIcon,
              height: 22,
              width: 22,
              padding: EdgeInsets.all(5),
              child: Image.asset(image, color: ColorRes.white),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText.capitalize ?? '',
                hintStyle: TextStyle(color: ColorRes.colorTextLight),
              ),
              style: TextStyle(color: ColorRes.colorTextLight),
              cursorColor: ColorRes.colorTextLight,
            ),
          ),
        ],
      ),
    );
  }
}
