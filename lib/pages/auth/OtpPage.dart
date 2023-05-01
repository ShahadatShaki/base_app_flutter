import 'dart:io';

import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/controller/EditProfileController.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';

class OtpPage extends BaseStatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());
  late BuildContext context;
  String phoneNumber;

  OtpPage({required this.phoneNumber, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Verify Phone Number"),
      body: getMainLayout(),
    );
  }

  late UserProfileModel profile;

  getMainLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              Text("Enter the verification code",
                style: TextStyle(fontSize: 24,
                  color: AppColors.textColorBlack,
                  fontWeight: FontWeight.w500),),
              margin(8),
              Text("Enter the 6 digit code went to", style: TextStyle(fontSize: 14,
                  color: AppColors.darkGray,
                  fontWeight: FontWeight.w400),),
              Text(phoneNumber, style: TextStyle(fontSize: 14, color: AppColors.textColorBlack, fontWeight: FontWeight.w400),),

              TextButton(
                style: Component.textButtonStyle(
                    radius: 8, backgroundColor: AppColors.appColor),
                onPressed: () async {
                  // await FirebaseAuth.instance.verifyPhoneNumber(
                  //   phoneNumber: phoneNumber,
                  //   verificationCompleted: (PhoneAuthCredential credential) {
                  //     Constants.showToast("verificationCompleted");
                  //   },
                  //   verificationFailed: (FirebaseAuthException e) {
                  //     Constants.showToast(
                  //         "Verification Failed : ${e.message}");
                  //   },
                  //   codeSent: (String verificationId, int? resendToken) {
                  //     Constants.showToast("codeSent");
                  //   },
                  //   codeAutoRetrievalTimeout: (String verificationId) {
                  //     Constants.showToast("codeAutoRetrievalTimeout");
                  //   },
                  // );
                },
                child: Component()
                    .buttonText(buttonTitle: "Continue", height: 40),
              )

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
