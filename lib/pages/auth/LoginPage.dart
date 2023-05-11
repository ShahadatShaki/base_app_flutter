import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/UserController.dart';
import 'package:base_app_flutter/pages/auth/OtpPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utility/AssetsName.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var phoneNumber = "";
  var firebaseUid = "Rd4x9hNsKkMmxiHpoIoO9dKzlMi2";
  var countryCode = "+880";
  Component component = Component();
  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        appBar: Component.appbar(name: "", showBackIcon: false),
        body: SingleChildScrollView(
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  width: double.infinity,
                  AssetsName.login_page_img,
                  fit: BoxFit.scaleDown,
                  height: 200,
                ),
                component.margin(20),
                RichText(
                  textAlign: TextAlign.left,
                  text: const TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'Welcome to',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColorBlack)),
                      TextSpan(
                          text: ' Travela',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: AppColors.appColor)),
                    ],
                  ),
                ),
                component.margin(8),
                const Text(
                  "Insert your phone number to continue",
                  style: TextStyle(color: AppColors.darkGray),
                ),
                component.margin(24),
                Container(
                  decoration: component.containerRoundShapeWithBorder(
                      borderColor: AppColors.appColor, borderWidth: 1),
                  child: TextField(
                      onChanged: (value) {
                        phoneNumber = countryCode + value;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        label: const Text("Phone Number"),
                        labelStyle: const TextStyle(color: AppColors.darkGray),
                        prefixIcon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: CountryCodePicker(
                            onChanged: (value) {
                              countryCode = value.code!;
                            },
                            initialSelection: 'BD',
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                          ),
                        ),
                      )),
                ),
                Container(
                  decoration: component.containerRoundShapeWithBorder(
                      borderColor: AppColors.appColor, borderWidth: 1),
                  child: TextField(

                      onChanged: (value) {
                        firebaseUid = value;
                      },
                      decoration: const InputDecoration(

                        border: InputBorder.none,
                        label: Text("Firebase Token"),
                        labelStyle: TextStyle(color: AppColors.darkGray),
                      )),
                ),
                component.margin(32),
                TextButton(
                  style: Component.textButtonStyle(
                      radius: 8, backgroundColor: AppColors.appColor),
                  onPressed: () async {

                    if(phoneNumber.length<8){
                      Constants.showFailedToast("Input a phone number");
                      return;
                    }

                    if(firebaseUid.isNotEmpty){
                      Constants.showToast("loging with FID");
                      controller.login(phoneNumber, firebaseUid);
                      return;
                    }
                    Component.progressDialog(context);

                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: phoneNumber,
                      verificationCompleted: (PhoneAuthCredential credential) {
                        Constants.showToast("verificationCompleted");
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        Component.dismissDialog(context);
                        Constants.showToast(
                            "Verification Failed : ${e.message}");
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        Component.dismissDialog(context);
                        Get.to(() => OtpPage(
                              phoneNumber: phoneNumber,
                              verificationId: verificationId,
                            ));
                        Constants.showToast("Code Sent to your Phone Number");
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        // Constants.showToast("codeAutoRetrievalTimeout");
                      },
                    );
                  },
                  child: Component()
                      .buttonText(buttonTitle: "Continue", height: 40),
                )
              ],
            ),
          ),
        ));
  }
}
