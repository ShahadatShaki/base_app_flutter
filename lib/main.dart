import 'package:base_app_flutter/pages/SplashScreen.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Fonts.dart';
import 'package:base_app_flutter/utility/NotificationClickHandler.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'utility/FirebaseService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  await FirebaseService.initializeFirebase();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    SharedPref.initData();

    return GetMaterialApp(
      title: 'Base App',
      theme: ThemeData(
        primarySwatch: AppColors.primary,
        fontFamily: Fonts.regularFont,
      ),
      initialRoute: "/",
      routes: {
        '/': (_) => SplashScreen(),
        // '/events': (BuildContext context) => EventsScreen(),
      },
      // home: SplashScreen(),
      // home: InboxPage(),
    );
  }
}
