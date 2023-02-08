import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/pages/guest/home/ExplorePage.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart';
import 'package:get/get.dart' hide FormData;
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/DioExceptions.dart';
import '../utility/Urls.dart';

class BookingController extends GetxController {
  var booking = BookingModel().obs;
  var id = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";
  var searchOptions = SearchOptions().obs;

  @override
  void onInit() {
    super.onInit();
  }

  getSingleBooking(String bookingId) async {
    if (callingApi) {
      return;
    }

    this.id = bookingId;

    callingApi = true;

    var client = http.Client();
    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/booking/$bookingId");
    var response = await client.get(uri, headers: await Urls.getHeaders());
    debugPrint(response.body);

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

  bookingRequest() async {

    if(searchOptions.value.checkinDateCalender == null){
      Constants.showToast("Select a date");
      return;
    }
    if(searchOptions.value.guestCount == 0){
      Constants.showToast("Select guest");
      return;
    }

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      'listing_id': id,
      'guests': searchOptions.value.guestCount,
      'from': Constants.calenderToString(searchOptions.value.checkinDateCalender!,"yyyy-MM-dd"),
      'to': Constants.calenderToString(searchOptions.value.checkoutDateCalender!,"yyyy-MM-dd"),
    });

    print(dio);
    try {
      var response = await dio.post('api/booking', data: formData);
      Get.to(()=> ExplorePage());
      print(response.data);
    } catch (e) {
      print("response: " + DioExceptions.fromDioError(e as DioError).message);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
