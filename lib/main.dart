import 'package:base_app_flutter/pages/ListingDetailsPage.dart';
import 'package:base_app_flutter/pages/SplashScreen.dart';
import 'package:base_app_flutter/pages/guest/home/InboxPage.dart';
import 'package:base_app_flutter/pages/guest/home/MyBookings.dart';
import 'package:base_app_flutter/utility/Fonts.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SharedPref.initData();
    return GetMaterialApp(
      title: 'Base App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: Fonts.regularFont,
      ),
      home: SplashScreen(),
      // home: InboxPage(),
    );
  }
}
