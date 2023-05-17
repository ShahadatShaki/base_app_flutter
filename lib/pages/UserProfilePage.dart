import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/UserController.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/pages/Webview.dart';
import 'package:base_app_flutter/pages/auth/EditProfilePage.dart';
import 'package:base_app_flutter/pages/auth/LoginPage.dart';
import 'package:base_app_flutter/pages/guest/UserHomePage.dart';
import 'package:base_app_flutter/pages/guest/home/MyBookings.dart';
import 'package:base_app_flutter/pages/host/HostHomePage.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/OfflineCache.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utility/AppColors.dart';

class UserProfilePage extends BaseStatelessWidget {
  final UserController controller = Get.put(UserController());
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
                  Get.to(() => EditProfilePage());
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
            section(
                icon: AssetsName.discount,
                title: "Get Discount",
                page: MyBookings()),
            section(
                icon: AssetsName.switch_to_host,
                title:
                    SharedPref.isHost ? "Switch to guest" : "Switch to hosting",
                page: SharedPref.isHost ? UserHomePage() : HostHomePage(),
                type: "switch"),
            section(
                icon: AssetsName.payment_history,
                title: "Payment History",
                page: MyBookings()),
            section(
                icon: AssetsName.terms_and_condition,
                title: "Terms & Conditions",
                page: WebviewPage(
                    title: "Terms & Conditions",
                    url: "https://travela.xyz/terms-conditions")),
            section(
                icon: AssetsName.about_us,
                title: "About Us",
                page: WebviewPage(
                    url: "https://travela.xyz/about", title: "About Us")),
            section(
                icon: AssetsName.call,
                title: "Contact with us",
                page: MyBookings()),
            section(title: "Log Out", page: LoginPage(), type: "logout"),
          ],
        ),
      ),
    );
  }

  section(
      {String icon = "", String title = "", dynamic page, String type = ""}) {
    return Column(
      children: [
        Ink(
          decoration: containerRoundShape(),
          child: InkWell(
            onTap: () {
              if (type == "switch") {
                SharedPref.putBool(
                    SharedPref.CURRENT_ROLL_HOST, !SharedPref.isHost);
                SharedPref.initData();
                Get.off(page);
              } else if (type == "logout") {
                SharedPref.clear();
                OfflineCache.clearData();
                Get.offAll(page);
              } else {
                Get.to(page);
              }
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  icon.isEmpty
                      ? const SizedBox()
                      : Component.showIconStatic(name: icon),
                  icon.isEmpty ? const SizedBox() : margin(12),
                  Expanded(
                      child: Text(
                    title,
                    style: Component.ts16Gray500(),
                  )),
                  Component.showIconStatic(name: AssetsName.arrow_right, size: 16),
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
