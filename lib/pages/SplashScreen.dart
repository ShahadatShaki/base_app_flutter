import 'dart:async';

import 'package:base_app_flutter/pages/auth/LoginPage.dart';
import 'package:base_app_flutter/pages/guest/UserHomePage.dart';
import 'package:base_app_flutter/pages/host/HostHomePage.dart';
import 'package:base_app_flutter/utility/NotificationClickHandler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/SharedPref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    setupInteractedMessage();

    Timer(Duration(seconds: 1), () => checkLoginStatus());
    return Scaffold(
        body: Image.asset(
      "assets/images/splash_screen_img.png",
      height: double.infinity,
      width: double.infinity,
    ));
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  var notificationClicked = false;

  void _handleMessage(RemoteMessage message) {
    notificationClicked = true;
    NotificationClickHandler()
        .navigat(message.data["item_type"], message.data["item_id"]);
  }

  @override
  void initState() {
    super.initState();
  }

  void checkLoginStatus() async {
    if (notificationClicked) return;
    bool b = await SharedPref.getBool(SharedPref.IS_LOGIN);
    bool isHost = await SharedPref.getBool(SharedPref.CURRENT_ROLL_HOST);
    if (b) {
      if (isHost) {
        Get.off(HostHomePage());
      } else {
        Get.off(UserHomePage());
      }
    } else {
      Get.off(const LoginPage());
    }
  }
}
