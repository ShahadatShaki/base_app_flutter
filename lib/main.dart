import 'package:base_app_flutter/pages/SplashScreen.dart';
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
    return GetMaterialApp(
      title: 'Base App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Explora",
      ),
      home: SplashScreen(),
    );
  }
}
