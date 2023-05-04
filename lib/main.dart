import 'package:base_app_flutter/firebase_options.dart';
import 'package:base_app_flutter/pages/SplashScreen.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Fonts.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        primarySwatch: AppColors.primary,
        fontFamily: Fonts.regularFont,
      ),
      home: SplashScreen(),
      // home: InboxPage(),
    );
  }
}
