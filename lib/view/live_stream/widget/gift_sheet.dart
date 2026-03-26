import 'package:bubbly/languages/languages_keys.dart';
import 'package:bubbly/modal/setting/setting.dart';
import 'package:bubbly/modal/user/user.dart';
import 'package:bubbly/utils/assert_image.dart';
import 'package:bubbly/utils/colors.dart';
import 'package:bubbly/utils/const_res.dart';
import 'package:bubbly/utils/font_res.dart';
import 'package:bubbly/utils/my_loading/my_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GiftSheet extends StatelessWidget {
  final VoidCallback onAddShortzzTap;
  final User? user;
  final Function(Gifts? gifts) onGiftSend;
  final SettingData? settingData;

  const GiftSheet(
      {Key? key,
      required this.onAddShortzzTap,
      this.user,
      required this.onGiftSend,
      required this.settingData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, MyLoading myLoading, child) {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: myLoading.isDark ? ColorRes.colorPrimary : ColorRes.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        end: Alignment.centerRight,
                        begin: Alignment.centerLeft,
                        colors: [
                          ColorRes.colorPink,
                          ColorRes.colorTheme,
                        ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          myLoading.isDark ? icLogo : icLogoLight,
                          width: 30,
                          height: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '${user?.data?.myWallet}',
                          style: TextStyle(
                            fontFamily: FontRes.fNSfUiLight,
                            fontSize: 17,
                            color: ColorRes.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: onAddShortzzTap,
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          end: Alignment.centerRight,
                          begin: Alignment.centerLeft,
                          colors: [ColorRes.colorPink, ColorRes.colorTheme],
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${LKey.add.tr} $appName',
                        style: TextStyle(
                            fontFamily: FontRes.fNSfUiLight,
                            fontSize: 17,
                            color: ColorRes.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: settingData?.gifts?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    Gifts? gift = settingData?.gifts?[index];
                    return InkWell(
                      onTap: () {
                        if (gift!.coinPrice! < user!.data!.myWallet!) {
                          onGiftSend(gift);
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Insufficient Shortzz..! Please purchase shortzz'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        foregroundDecoration: BoxDecoration(
                            color: (gift?.coinPrice ?? 0) >
                                    (user?.data?.myWallet ?? 0)
                                ? ColorRes.colorPrimaryDark.withOpacity(0.7)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10)),
                        decoration: BoxDecoration(
                          color: ColorRes.colorPrimaryDark,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '${ConstRes.itemBaseUrl}${gift?.image}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  myLoading.isDark ? icLogo : icLogoLight,
                                  width: 20,
                                  height: 25,
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    NumberFormat.compact(locale: 'en')
                                        .format(gift?.coinPrice ?? 0),
                                    style: TextStyle(
                                        fontFamily: FontRes.fNSfUiLight,
                                        color: ColorRes.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
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
        ),
      );
    });
  }
}
