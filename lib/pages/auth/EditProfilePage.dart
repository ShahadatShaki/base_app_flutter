import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/controller/UserController.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';

class EditProfilePage extends BaseStatelessWidget {
  final UserController controller = Get.put(UserController());
  late BuildContext context;

  EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getUserProfile();

    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Edit Profile"),
      body: getMainLayout(),
    );
  }

  late UserProfileModel profile;

  getMainLayout() {
    profile = controller.profile.value;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    loadCircleImage(
                        imageUrl: profile.image.url, width: 100, height: 100),
                    Positioned(
                        bottom: 1,
                        right: 1,
                        child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: Component.containerRoundShapeWithBorder(
                                color: AppColors.appColor,
                                size: 50,
                                borderColor: AppColors.white,
                                borderWidth: 2),
                            child: showIcon(
                                name: AssetsName.edit,
                                size: 14,
                                color: AppColors.white)))
                  ],
                ),
              ),
              const SizedBox(height: 24),
              bookNowButton()
            ],
          ),
        ),
      ),
    );
  }

  bookNowButton() {
    return TextButton(
      style: Component.textButtonStyle(radius: 8),
      onPressed: () {},
      child: buttonText(buttonTitle: "Request for book"),
    );
  }
}
