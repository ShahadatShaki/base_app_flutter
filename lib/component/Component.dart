import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utility/AppColors.dart';
import '../utility/AssetsName.dart';

typedef DatePickerCallBack = void Function(DateTime dateTime);

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

  static TextStyle ts16Gray500({Color color = AppColors.darkGray}) {
    return TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w500);
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Lottie.asset('assets/animation/loading_animation.json',
          height: 200, width: 200),
    );
  }

  static emptyView(var message, var image) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [Lottie.asset(image, height: 200, width: 200), Text(message)],
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

  pickDate({required BuildContext context, DatePickerCallBack? onDatePick}) {
    DateTime dateTime = DateTime.now();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // title: Text("Test Title"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: SfDateRangePicker(
                      onSelectionChanged: (args) {
                        if (args.value is DateTime) {
                          dateTime = args.value;
                        }
                        int i = 0;
                      },
                      selectionMode: DateRangePickerSelectionMode.single,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: Component.textButtonStyle(
                              radius: 8, backgroundColor: AppColors.darkGray),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: buttonText(buttonTitle: "Cancel", height: 30),
                        ),
                      ),
                      margin(16),
                      Expanded(
                        child: TextButton(
                          style: Component.textButtonStyle(radius: 8),
                          onPressed: () {
                            if (onDatePick != null) onDatePick(dateTime);
                            Navigator.pop(context);
                          },
                          child: buttonText(buttonTitle: "Done", height: 30),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget margin(double margin) {
    return SizedBox(
      height: margin,
      width: margin,
    );
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

  static appbar({required String name, bool showBackIcon = true}) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      leading: showBackIcon
          ? InkWell(
              onTap: () => {Get.back()},
              child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Component.showIcon(name: AssetsName.back)),
            )
          : SizedBox(),
      title: Container(
        height: 50,
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

  static appbarDark({required String name, bool showBackIcon = true}) {
    return AppBar(
      backgroundColor: AppColors.black,
      elevation: 0,
      leading: showBackIcon
          ? InkWell(
              onTap: () => {Get.back()},
              child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Component.showIcon(
                      name: AssetsName.back, color: AppColors.white)),
            )
          : SizedBox(),
      title: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 40),
        child: Text(
          name,
          style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18),
        ),
      ),
    );
  }

  static textButtonStyle(
      {double radius = 8,
      Color backgroundColor = AppColors.appColor,
      Color foregroundColor = Colors.white,
      double fontSize = 16}) {
    return TextButton.styleFrom(
      shape: Component.roundShape(radius: radius),
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
      textStyle: TextStyle(fontSize: fontSize),
    );
  }

  buttonText(
      {required String buttonTitle,
      double width = double.infinity,
      double fontSize = 14,
      double height = 40}) {
    return Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Text(
          buttonTitle,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w500),
        ));
  }

  static containerRoundShape({
    double size = 8,
    Color color = AppColors.separator,
  }) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(size)), color: color);
  }

  static containerRoundShapeWithBorder({
    double size = 8,
    Color color = AppColors.transparent,
    double borderWidth = 0,
    Color borderColor = AppColors.separator,
  }) {
    return BoxDecoration(
        border: Border.all(width: borderWidth, color: borderColor),
        borderRadius: BorderRadius.all(Radius.circular(size)),
        color: color);
  }

  Widget loadImage(
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
          placeholder: (context, url) {
            return Image.asset(
              AssetsName.generic_placeholder,
              fit: BoxFit.cover,
            );
          },
          errorWidget: (context, url, error) {
            return Image.asset(
              AssetsName.generic_placeholder,
              fit: BoxFit.cover,
            );
          },
        ));
  }

  Widget loadCircleImage(
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
      placeholder: (context, url) {
        return Image.asset(
          AssetsName.generic_placeholder,
          fit: BoxFit.cover,
        );
      },
      errorWidget: (context, url, error) {
        return Image.asset(
          AssetsName.generic_placeholder,
          fit: BoxFit.cover,
        );
      },
    ));
  }

  Widget loadCircleImageFromFile(
      {required File imageUrl,
      double width = double.infinity,
      double height = 50,
      double cornerRadius = 0}) {
    return ClipOval(
        // borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
        child: Image.file(
      imageUrl,
      fit: BoxFit.cover,
      width: width,
      height: height,
    ));
  }

  lineHorizontal({
    EdgeInsets? margin,
    Color color = AppColors.lineColor,
  }) {
    return Container(
      margin: margin,
      width: double.infinity,
      height: 1,
      color: color,
    );
  }

  lineVertical({EdgeInsets? margin}) {
    return Container(
      margin: margin,
      width: 1,
      height: double.infinity,
      color: AppColors.lineColor,
    );
  }
}
