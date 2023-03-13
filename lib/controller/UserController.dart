import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/OfflineCache.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../utility/Urls.dart';

class UserController extends GetxController {
  var profile = UserProfileModel().obs;
  var listingId = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";


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
    } else {
      // errorMessage = response.
    }
    apiCalled.value = true;
    callingApi = false;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getProfileDataOffline() async {
    var offRes = await OfflineCache.getOffline(OfflineCache.USER_PROFILE);
    if (offRes != null) {
      profile.value = UserProfileModel.fromJson(offRes);
    }
  }
}
