import 'dart:async';

import 'package:base_app_flutter/pages/auth/LoginPage.dart';
import 'package:base_app_flutter/pages/guest/UserHomePage.dart';
import 'package:base_app_flutter/pages/host/HostHomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utility/SharedPref.dart';

class SplashScreen extends StatelessWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () => checkLoginStatus());
    return Scaffold(
        body: Image.asset(
      "assets/images/splash_screen_img.png",
      height: double.infinity,
      width: double.infinity,
    ));
  }

  void checkLoginStatus() async {
    bool b = await SharedPref.getBool(SharedPref.IS_LOGIN);
    bool isHost = await SharedPref.getBool(SharedPref.CURRENT_ROLL_HOST);
    if (b) {
      if(isHost) {
        // Get.off(HostHomePage());
        Get.off(LoginPage());
      }else{
        Get.off(UserHomePage());
      }
    } else {
      Get.off(UserHomePage());
    }
  }
}
