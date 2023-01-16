import 'package:base_app_flutter/pages/BottomNavPage.dart';
import 'package:base_app_flutter/pages/ListItemPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/SharedPref.dart';
import 'LoginPage.dart';


class SplashScreen extends StatelessWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    checkLoginStatus();
    return Scaffold(
        body: Image.asset(
      "assets/images/splash_screen.png",
      height: double.infinity,
      width: double.infinity,
    ));
  }

  void checkLoginStatus() async {
    bool b = await SharedPref.getBool(SharedPref.IS_LOGIN);
    print(b);
    if(b){
      Get.off(BottomNavPage());
    }else{
      Get.off(BottomNavPage());
    }
  }
}
