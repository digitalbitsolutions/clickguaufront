import 'dart:io';
import 'dart:ui';

import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageVideoMsgScreen extends StatefulWidget {
  final String? image;
  final Function({String? text}) onIVSubmitClick;

  const ImageVideoMsgScreen(
      {Key? key, this.image, required this.onIVSubmitClick})
      : super(key: key);

  @override
  State<ImageVideoMsgScreen> createState() => _ImageVideoMsgScreenState();
}

class _ImageVideoMsgScreenState extends State<ImageVideoMsgScreen> {
  TextEditingController imageTextController = TextEditingController();
  FocusNode textFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
        decoration: BoxDecoration(
          color: ColorRes.colorPrimaryDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: InkWell(
          onTap: () {
            textFocusNode.unfocus();
            setState(() {});
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, top: 12, right: 10, bottom: 3),
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close_outlined,
                        color: ColorRes.white,
                        size: 22,
                      ),
                    ),
                    Center(
                      child: Text(
                        LKey.sendMedia.tr,
                        style: TextStyle(
                            fontFamily: FontRes.fNSfUiMedium,
                            fontSize: 18,
                            color: ColorRes.colorTextLight),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                color: ColorRes.colorTextLight,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    width: MediaQuery.of(context).size.width / 2.7,
                    margin: EdgeInsets.symmetric(horizontal: 7),
                    decoration: BoxDecoration(
                      color: ColorRes.colorPrimary,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: widget.image == null || widget.image!.isEmpty
                          ? Image.asset(
                              icUserPlaceHolder,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(widget.image ?? ''),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            LKey.writeMessage.tr,
                            style: TextStyle(
                                fontFamily: FontRes.fNSfUiRegular,
                                fontSize: 15,
                                color: ColorRes.colorTextLight),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 6,
                          margin: EdgeInsets.only(right: 7, left: 9),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: ColorRes.colorPrimary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextField(
                              controller: imageTextController,
                              focusNode: textFocusNode,
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              autofocus: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              style: TextStyle(
                                color: ColorRes.white,
                                fontFamily: FontRes.fNSfUiRegular,
                                fontSize: 13,
                                letterSpacing: 0.7,
                                height: 1.3,
                              ),
                              cursorHeight: 15,
                              cursorColor: ColorRes.colorTextLight,
                              textCapitalization: TextCapitalization.sentences),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onIVSubmitClick(text: imageTextController.text);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorRes.colorPrimary),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  child: Text(
                    LKey.submit.tr.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FontRes.fNSfUiSemiBold,
                      letterSpacing: 1,
                      color: ColorRes.colorIcon,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
