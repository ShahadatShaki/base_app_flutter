import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/UserControllerController.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/DataController.dart';
import '../utility/AppColors.dart';

class UserProfilePage extends BaseStatelessWidget {
  final UserControllerController controller = Get.put(UserControllerController());
  late UserProfileModel profile;
  UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getUserProfile();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Profile"),
      body: Obx(()=> getMainLayout()),
    );
  }

  getMainLayout() {
    profile = controller.profile.value;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            loadCircleImage(imageUrl: profile.image.url, width: 100, height: 100),
            Text(profile.firstName)
          ],
        ),
      ),
    );
  }
}
