import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/pages/guest/home/ExplorePage.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/DioExceptions.dart';
import '../utility/Urls.dart';

class BookingDetailsController extends GetxController {
  var booking = BookingModel().obs;
  var dataList = <BookingModel>[].obs;
  var id = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";
  bool hasMoreData = true;
  var page = 1;

  var isTermsChecked = false.obs;

  @override
  void onInit() {

    super.onInit();
  }

  getSingleBooking(String bookingId) async {
    // apiCalled.value = false;

    if (callingApi) {
      return;
    }

    this.id = bookingId;

    callingApi = true;

    var client = http.Client();
    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/booking/$bookingId");
    print(uri);
    var response = await client.get(uri, headers: await Urls.getHeaders());
    print(response.body);

    if (response.statusCode == 200) {
      var res = ApiResponse<BookingModel>.fromJson(
          json.decode(response.body), (data) => BookingModel.fromJson(data));
      booking.value = res.data!;
    } else {
      // errorMessage = response.
    }
    apiCalled.value = true;
    callingApi = false;
  }


  @override
  void dispose() {
    super.dispose();
  }

}
