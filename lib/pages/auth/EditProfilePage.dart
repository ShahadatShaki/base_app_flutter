import 'dart:io';

import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/controller/EditProfileController.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';

class EditProfilePage extends BaseStatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());
  late BuildContext context;

  EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getUserProfile();

    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Edit Profile"),
      body: Obx(() => getMainLayout()),
    );
  }

  late UserProfileModel profile;

  getMainLayout() {
    profile = controller.profile.value;
    controller.editProfileUi();
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              InkWell(
                onTap: () {
                  controller.pickImage();
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      controller.imageUrl.value.isEmpty
                          ? loadCircleImage(
                              imageUrl: profile.image.url,
                              width: 100,
                              height: 100)
                          : loadCircleImageFromFile(
                              imageUrl: File(controller.imageUrl.value),
                              width: 100,
                              height: 100,
                            ),
                      Positioned(
                          bottom: 1,
                          right: 1,
                          child: Container(
                              padding: EdgeInsets.all(6),
                              decoration:
                                  Component.containerRoundShapeWithBorder(
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
              ),
              margin(24),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: Component.containerRoundShapeWithBorder(
                          borderWidth: 1.5, borderColor: AppColors.darkGray),
                      child: TextField(
                          controller: controller.firstNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            label: const Text("First Name"),
                            labelStyle: TextStyle(color: AppColors.darkGray),
                            prefixIcon: Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: showIcon(name: AssetsName.guest),
                            ),
                          )),
                    ),
                  ),
                  margin(16),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: Component.containerRoundShapeWithBorder(
                          borderWidth: 1.5, borderColor: AppColors.darkGray),
                      child: TextField(
                          controller: controller.lastNameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            label: const Text("Last Name"),
                            labelStyle: TextStyle(color: AppColors.darkGray),
                            prefixIcon: Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: showIcon(name: AssetsName.guest),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              margin(16),
              InkWell(
                onTap: () {
                  controller.pickDob(context);
                },
                child: Container(
                  decoration: Component.containerRoundShapeWithBorder(
                      borderWidth: 1.5, borderColor: AppColors.darkGray),
                  child: TextField(
                      enabled: false,
                      controller: controller.dateOfBirth,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        label: const Text("Date Of Birth"),
                        labelStyle: TextStyle(color: AppColors.darkGray),
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: showIcon(name: AssetsName.calender),
                        ),
                      )),
                ),
              ),
              margin(16),
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
