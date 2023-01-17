import 'dart:async';

import 'package:base_app_flutter/pages/BottomNavPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/SharedPref.dart';

class SplashScreen extends StatelessWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () => checkLoginStatus());
    return Scaffold(
        body: Image.asset(
      "assets/images/splash_screen.png",
      height: double.infinity,
      width: double.infinity,
    ));
  }

  void checkLoginStatus() async {
    bool b = await SharedPref.getBool(SharedPref.IS_LOGIN);
    if (b) {
      Get.off(BottomNavPage());
    } else {
      Get.off(BottomNavPage());
    }
  }
}
