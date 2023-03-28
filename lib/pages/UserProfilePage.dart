import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/UserController.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/pages/Webview.dart';
import 'package:base_app_flutter/pages/auth/EditProfilePage.dart';
import 'package:base_app_flutter/pages/guest/home/MyBookings.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/AppColors.dart';

class UserProfilePage extends BaseStatelessWidget {
  final UserController controller =
      Get.put(UserController());
  late UserProfileModel profile;

  UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getUserProfile();
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Profile", showBackIcon: false),
      body: Obx(() => getMainLayout()),
    );
  }

  getMainLayout() {
    profile = controller.profile.value;
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            loadCircleImage(
                imageUrl: profile.image.url, width: 100, height: 100),
            margin(16),
            Text(
              profile.fullName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            margin(8),
            Text(
              profile.phone,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGray),
            ),
            margin(16),
            TextButton(
                onPressed: () {
                  Get.to(()=> EditProfilePage());
                },
                style: Component.textButtonStyle(
                    backgroundColor: AppColors.gray.shade100,
                    foregroundColor: AppColors.appColor),
                child: buttonText(
                    buttonTitle: "Edit Profile",
                    height: 30,
                    width: 100,
                    fontSize: 14)),
            lineHorizontal(
                margin: EdgeInsets.only(top: 24, bottom: 24),
                color: AppColors.gray.shade100),
            section(AssetsName.discount, "Get Discount", MyBookings()),
            section(
                AssetsName.switch_to_host, "Switch to hosting", MyBookings()),
            section(
                AssetsName.payment_history, "Payment History", MyBookings()),
            section(AssetsName.terms_and_condition, "Terms & Conditions",
                WebviewPage(title: "Terms & Conditions", url: "https://travela.xyz/terms-conditions")),
            section(AssetsName.about_us, "About Us", WebviewPage(url: "https://travela.xyz/about", title: "About Us")),
            section(AssetsName.call, "Contact with us", MyBookings()),
            section("", "Log Out", MyBookings()),
          ],
        ),
      ),
    );
  }

  section(String icon, String s, dynamic page) {
    return Column(
      children: [
        Ink(
          decoration: containerRoundShape(),
          child: InkWell(
            onTap: () {
              Get.to(page);
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  icon.isEmpty ? const SizedBox() : Component.showIcon(name: icon),
                  icon.isEmpty ? const SizedBox() : margin(12),
                  Expanded(
                      child: Text(
                    s,
                    style: Component.ts16Gray500(),
                  )),
                  Component.showIcon(name: AssetsName.arrow_right, size: 16),
                ],
              ),
            ),
          ),
        ),
        margin(16)
      ],
    );
  }
}
