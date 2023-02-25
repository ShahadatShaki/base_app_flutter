import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/pages/guest/home/ExplorePage.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart';
import 'package:get/get.dart' hide FormData;
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../pages/BookingDetailsPage.dart';
import '../utility/DioExceptions.dart';
import '../utility/Urls.dart';

class UserControllerController extends GetxController {
  var profile = UserProfileModel().obs;
  var listingId = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";

  @override
  void onInit() {
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
          json.decode(response.body), (data) => UserProfileModel.fromJson(data));
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
}
