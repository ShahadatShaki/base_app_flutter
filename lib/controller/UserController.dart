import 'dart:async';
import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/pages/guest/UserHomePage.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/DioExceptions.dart';
import 'package:base_app_flutter/utility/OfflineCache.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' hide FormData;
import 'package:http/http.dart' as http;

import '../utility/Urls.dart';

class UserController extends BaseController {
  var profile = UserProfileModel().obs;

  @override
  void onInit() {
    getProfileDataOffline();
    super.onInit();
  }

  getUserProfile() async {
    if (callingApi) {
      return;
    }
    callingApi = true;

    var client = http.Client();
    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/auth/profile");
    print(uri);
    var response = await client.get(uri, headers: await Urls.getHeaders());
    print(response.body);

    if (response.statusCode == 200) {
      var res = ApiResponse<UserProfileModel>.fromJson(
          json.decode(response.body),
          (data) => UserProfileModel.fromJson(data));

      OfflineCache.saveOfflineJson(
          OfflineCache.USER_PROFILE, res.data?.toJson());
      profile.value = res.data!;
      await SharedPref.putString(SharedPref.USER_ID, profile.value.id);
    } else {
      // errorMessage = response.
    }
    apiCalled.value = true;
    callingApi = false;
  }

  login(String phone, String uid) async {
    Component.progressDialog(context!);

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      "firebase_token": uid,
      "phone": phone,
    });

    try {
      var response = await dio.post('api/auth/login', data: formData);
      Component.dismissDialog(context!);

      if (response.data["success"]) {
        UserProfileModel userProfile =
            UserProfileModel.fromJson(response.data["data"]);
        if (userProfile.newUser) {
        } else {
          await SharedPref.putString(
              SharedPref.AUTH_KEY, "Bearer ${userProfile.accessToken}");
          await SharedPref.putBool(SharedPref.IS_LOGIN, true);
          getUserProfile();
          sendFCMToken();
          SharedPref.initData();
          Get.off(UserHomePage());
        }
      } else {
        Constants.showToast(response.data["message"]);
      }
    } catch (e) {
      Component.dismissDialog(context!);
      Constants.showToast(
          "response: ${DioExceptions.fromDioError(e as DioError).message}");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void getProfileDataOffline() async {
    var offRes = await OfflineCache.getOffline(OfflineCache.USER_PROFILE);
    if (offRes != null) {
      profile.value = UserProfileModel.fromJson(offRes);
    }
  }

  final countDown = 5.obs;
  late Timer _timer;

  void startTimer() {
    countDown.value = 5;
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countDown.value == 0) {
          timer.cancel();
        } else {
          countDown.value--;
        }
      },
    );
  }

  void sendFCMToken() {
    FirebaseMessaging.instance.getToken().then(
      (value) async {
        print(value);

        Dio dio = await Urls.getDio();
        var formData = FormData.fromMap({
          "fcm_token": value,
        });

        try {
          var response = await dio.post('api/user/fcm-token', data: formData);
          int i = 0;
        } catch (e) {
          Constants.showToast(
              "response: ${DioExceptions.fromDioError(e as DioError).message}");
        }
      },
    );
  }
}
