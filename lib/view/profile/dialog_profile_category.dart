import 'package:bubbly/api/api_service.dart';
import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/profileCategory/profile_category.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DialogProfileCategory extends StatefulWidget {
  final Function function;

  final String categoryId;
  DialogProfileCategory({required this.function, required this.categoryId});

  @override
  _DialogProfileCategoryState createState() => _DialogProfileCategoryState();
}

class _DialogProfileCategoryState extends State<DialogProfileCategory> {
  List<ProfileCategoryData> mList = [];

  @override
  void initState() {
    getProfileCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return Container(
        height: 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          color: myLoading.isDark ? ColorRes.colorPrimary : ColorRes.white,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              height: 55,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    LKey.chooseCategory.tr,
                    style: TextStyle(
                        fontSize: 16, fontFamily: FontRes.fNSfUiSemiBold),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close_rounded),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: !myLoading.isDark
                  ? ColorRes.colorPrimary
                  : ColorRes.greyShade100,
              height: 0.5,
              thickness: 0.5,
            ),
            SizedBox(height: 4),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: mList.length,
                itemBuilder: (context, index) {
                  bool isSelected = mList[index].profileCategoryId ==
                      int.parse(widget.categoryId);
                  return InkWell(
                    onTap: () {
                      if (isSelected) {
                        widget.function(null);
                      } else {
                        widget.function(mList[index]);
                      }
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: myLoading.isDark
                            ? ColorRes.colorPrimaryDark
                            : ColorRes.greyShade100,
                        border: Border.all(
                            color: isSelected
                                ? ColorRes.colorPink
                                : Colors.transparent,
                            width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                                ConstRes.itemBaseUrl +
                                    mList[index].profileCategoryImage!,
                                fit: BoxFit.cover,
                                color: ColorRes.colorPink,
                                height: 50,
                                width: 50),
                          ),
                          SizedBox(height: 7),
                          Text(
                            mList[index].profileCategoryName ?? '',
                            style: TextStyle(
                              fontFamily: FontRes.fNSfUiBold,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  void getProfileCategory() {
    ApiService().getProfileCategoryList().then((value) {
      mList = value.data ?? [];

      setState(() {});
    });
  }
}
