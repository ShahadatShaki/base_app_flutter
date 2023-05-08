import 'package:base_app_flutter/pages/SplashScreen.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Fonts.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utility/FirebaseService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseService.initializeFirebase();

  runApp(const MyApp());
}
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//
//   if (kDebugMode) {
//     print("Handling a background message: ${message.messageId}");
//     print('Message data: ${message.data}');
//     print('Message notification: ${message.notification?.title}');
//     print('Message notification: ${message.notification?.body}');
//   }
// }

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
