import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

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

  dialog(BuildContext context) {
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

  showBottommsheetDialog(BuildContext context) {
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
                  onPressed: () => Navigator.pop(context),
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
        onTap: () => {
          Get.back()
        },
        child: Padding(
            padding: const EdgeInsets.all(14),
            child: Component.showIcon(name: AssetsName.back)),
      ),
      title: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(right: 40),
        child:  Text(
          name,
          style: const TextStyle(color: AppColors.textColorBlack, fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ),
    );
  }
}
