import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/DataController.dart';
import '../utility/AppColors.dart';

class LoginPage extends StatelessWidget {
  final DataController controller = Get.put(DataController());

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(color: AppColors.textColorBlack),
        title: const Text(
          "Notification",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textColorBlack),
        ),
      ),
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [],
    );
  }
}
