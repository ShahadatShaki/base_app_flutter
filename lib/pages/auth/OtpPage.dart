import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/controller/UserController.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';

class OtpPage extends BaseStatelessWidget {
  final UserController controller = Get.put(UserController());
  late BuildContext context;
  String phoneNumber;
  String verificationId;
  String pin = "";

  OtpPage({required this.phoneNumber, required this.verificationId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    this.context = context;
    controller.context = context;
    controller.startTimer();
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
            children: [
              margin(32),
              const Text(
                "Enter the verification code",
                style: TextStyle(
                    fontSize: 24,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w500),
              ),
              margin(16),
              const Text(
                "Enter the 6 digit code went to",
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w400),
              ),
              margin(4),
              Text(
                phoneNumber,
                style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textColorBlack,
                    fontWeight: FontWeight.w400),
              ),
              margin(24),
              pinInput(),
              margin(24),
              resendOtpView(),
              margin(48),
              TextButton(
                style: Component.textButtonStyle(
                    radius: 8, backgroundColor: AppColors.appColor),
                onPressed: () async {
                  // Create a PhoneAuthCredential with the code
                  Component.progressDialog();
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: pin);

                    // Sign the user in (or link) with the credential
                    await FirebaseAuth.instance
                        .signInWithCredential(credential);
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                      if (user != null) {
                        Component.dismissDialog();
                        print(user.uid);
                        controller.login(phoneNumber, user.uid);
                      } else {
                        Constants.showFailedToast("Something is wrong ");
                        Component.dismissDialog();
                      }
                    });
                  } catch (e) {
                    Component.dismissDialog();
                    Constants.showToast("Wrong Code");
                  }
                },
                child:
                    Component().buttonText(buttonTitle: "Continue", height: 40),
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

  pinInput() {
    final defaultPinTheme = PinTheme(
      width: 44,
      height: 44,
      textStyle: const TextStyle(
          fontSize: 20,
          color: AppColors.textColorBlack,
          fontWeight: FontWeight.w500),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.darkGray),
        color: AppColors.lightestLineColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.appColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      length: 6,
      onChanged: (value) {
        pin = value;
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
    );
  }

  resendOtpView() {
    return Obx(() => controller.countDown.value == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              const Text(
                "Didn’t receive the code?",
                style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w400),
              ),
              InkWell(
                onTap: () async{
                  Component.progressDialog();
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: phoneNumber,
                    verificationCompleted: (PhoneAuthCredential credential) {
                      Constants.showToast("verificationCompleted");
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      Component.dismissDialog();
                      Constants.showToast(
                          "Verification Failed : ${e.message}");
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      Component.dismissDialog();
                      this.verificationId = verificationId;
                      Constants.showToast("Code Sent to your Phone Number");
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      // Constants.showToast("codeAutoRetrievalTimeout");
                    },
                  );

                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    "Resend code",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.appColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          )
        : Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            decoration:
                containerRoundShape(size: 8, color: AppColors.separator),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                showIcon(name: AssetsName.call),
                margin(8),
                Text(
                  "${controller.countDown.value}",
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textColorBlack,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ));
  }
}
