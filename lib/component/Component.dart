import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../model/SearchOptions.dart';
import '../utility/AppColors.dart';
import '../utility/AssetsName.dart';

class Component {
  static TextStyle textStyle16bkw500({Color color = AppColors.textColorBlack}) {
    return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500);
  }

  static TextStyle textStyle16bkw700({Color color = AppColors.textColorBlack}) {
    return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700);
  }

  static TextStyle textStyle14bkw700({Color color = AppColors.textColorBlack}) {
    return TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w700);
  }

  static TextStyle textStyle14bkw500({Color color = AppColors.textColorBlack}) {
    return TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w500);
  }

  static TextStyle textStyle12bkw500({Color color = AppColors.textColorBlack}) {
    return TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500);
  }

  static TextStyle textStyle12bkw700({Color color = AppColors.textColorBlack}) {
    return TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700);
  }

  static TextStyle textStyle12grayW500() {
    return const TextStyle(
        color: AppColors.darkGray, fontSize: 12, fontWeight: FontWeight.w500);
  }

  static TextStyle textStyle12grayW700() {
    return const TextStyle(
        color: AppColors.darkGray, fontSize: 12, fontWeight: FontWeight.w700);
  }

  static Widget showIcon(
      {required String name, double size = 20, Color? color}) {
    return SvgPicture.asset(
      name,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget loadingView() {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Lottie.asset('assets/animation/loading_animation.json',
            height: 200, width: 200),
      ),
    );
  }

  static emptyView(var message, var image) {
    return Expanded(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(image, height: 200, width: 200),
            Text(message)
          ],
        ),
      ),
    );
  }

  static dialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text("Test Title"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Test Title"),
                  Text("Test Title"),
                  ElevatedButton(
                      onPressed: () => {Navigator.pop(context)},
                      child: Text("Close"))
                ],
              ),
            ),
          );
        });
  }

  static showBottommsheetDialog(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                ElevatedButton(
                  child: const Text('Close BottomSheet'),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static roundShape({double radius = 8}) {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)));
  }

  static dropShadow() {
    return BoxShadow(
      color: Colors.grey.withOpacity(.2),
      blurRadius: 8.0, // soften the shadow
      spreadRadius: 0.0, //extend the shadow
      offset: const Offset(
        5.0, // Move to right 10  horizontally
        6.0, // Move to bottom 10 Vertically
      ),
    );
  }

  static appbar({required String name}) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: InkWell(
        onTap: () => {Get.back()},
        child: Padding(
            padding: const EdgeInsets.all(14),
            child: Component.showIcon(name: AssetsName.back)),
      ),
      title: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 40),
        child: Text(
          name,
          style: const TextStyle(
              color: AppColors.textColorBlack,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
      ),
    );
  }

  static textButtonStyle({double radius = 8}) {
    return TextButton.styleFrom(
      shape: Component.roundShape(radius: radius),
      foregroundColor: Colors.white,
      backgroundColor: AppColors.appColor,
      textStyle: const TextStyle(fontSize: 16),
    );
  }

  static textButtonText(
      {required String buttonTitle, double width = double.infinity}) {
    return Container(
        height: 40,
        width: width,
        alignment: Alignment.center,
        child: Text(
          buttonTitle,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ));
  }

  static containerRoundShape({double size = 8}) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: AppColors.separator);
  }

  static Widget loadImage(
      {required String imageUrl,
      double width = double.infinity,
      double height = 50,
      double cornerRadius = 0}) {
    return ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: width,
          height: height,
          imageUrl: imageUrl,
          fadeInCurve: Curves.easeIn,
          errorWidget: (context, url, error) {
            return Image.asset(
              AssetsName.generic_placeholder,
              fit: BoxFit.cover,
            );
          },
        ));
  }

  static Widget loadCircleImage(
      {required String imageUrl,
      double width = double.infinity,
      double height = 50,
      double cornerRadius = 0}) {
    return ClipOval(
        // borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        child: CachedNetworkImage(
      fit: BoxFit.cover,
      width: width,
      height: height,
      imageUrl: imageUrl,
      fadeInCurve: Curves.easeIn,
      errorWidget: (context, url, error) {
        return Image.asset(
          AssetsName.generic_placeholder,
          fit: BoxFit.cover,
        );
      },
    ));
  }

  static showGuestCountBottomSheet(
      BuildContext context, var searchOptionsRx) {
    var bottomSheet;
    SearchOptions searchOptions = searchOptionsRx.value;
    SearchOptions damiSearchOption = SearchOptions();
    damiSearchOption.guestCount = searchOptions.guestCount;
    damiSearchOption.childCount = searchOptions.childCount;
    damiSearchOption.infantCount = searchOptions.infantCount;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setModelState /*You can rename this!*/) {
          bottomSheet = setModelState;

          return Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    const Expanded(
                        child: Text(
                      'Select Guest Size',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )),
                    InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGray,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                const SizedBox(height: 24),
                showCounterInput(bottomSheet,damiSearchOption, "Adults", "Ages 13 or above"),
                Container(
                  margin: EdgeInsets.only(top: 24, bottom: 24),
                  height: 1,
                  color: AppColors.lightestLineColor,
                ),
                showCounterInput(bottomSheet,damiSearchOption,"Child", "Ages 2-12"),
                Container(
                  margin: EdgeInsets.only(top: 24, bottom: 24),
                  height: 1,
                  color: AppColors.lightestLineColor,
                ),
                showCounterInput(bottomSheet,damiSearchOption,"Infants", "Under 2"),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.lineColor,
                                width: 1.0,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          foregroundColor: AppColors.darkGray,
                          backgroundColor: AppColors.white,
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text('Cancel')),
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                        style: Component.textButtonStyle(),
                        onPressed: () {
                          // setState(() {
                            searchOptions.guestCount =
                                damiSearchOption.guestCount;
                            searchOptions.childCount =
                                damiSearchOption.childCount;
                            searchOptions.infantCount =
                                damiSearchOption.infantCount;
                          // });

                            searchOptionsRx.value = searchOptions;
                            searchOptionsRx.refresh();
                          Get.back(result: damiSearchOption);
                        },
                        child: Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: const Text('Done')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  static showCounterInput(var bottomSheet, SearchOptions damiSearchOption, String title, String subtitle) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textColorBlack)),
                SizedBox(height: 8),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.darkGray)),
              ],
            ),
          ),
          InkWell(
              onTap: () {
                bottomSheet(() {
                  damiSearchOption.changeCount(title, -1);
                });
              },
              child: Component.showIcon(
                name: AssetsName.minus,
                size: 40,
              )),
          Container(
            margin: EdgeInsets.only(right: 12, left: 12),
            child: Text("${damiSearchOption.getCount(title)} ",
                style: const TextStyle(
                    fontSize: 16, color: AppColors.textColorBlack)),
          ),
          InkWell(
              onTap: () {
                bottomSheet(() {
                  damiSearchOption.changeCount(title, 1);
                });
              },
              child: Component.showIcon(name: AssetsName.plus, size: 40))
        ],
      ),
    );
  }

}
