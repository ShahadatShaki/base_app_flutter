import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/DioExceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';

import '../utility/Urls.dart';

class RatingController extends BaseController {
  var booking = BookingModel().obs;
  var id = "";
  var page = 1;

  var rateGuestsBehaviour = 0.obs;
  var rateHouseRules = 0.obs;
  var rateGuestsCommunication = 0.obs;

  late TextEditingController reviewBodyController;

  @override
  void onInit() {
    reviewBodyController = TextEditingController();
    super.onInit();
  }

  getSingleBooking(String bookingId) async {
    // apiCalled.value = false;

    if (callingApi) {
      return;
    }

    this.id = bookingId;
    callingApi = true;

    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/booking/$bookingId");
    try {
      var response = await get(uri);
      var res = ApiResponse<BookingModel>.fromJson(
          json.decode(response.body), (data) => BookingModel.fromJson(data));
      booking.value = res.data!;
    } catch (e) {
      error.value = true;
      showFailedToast(errorMessage);
    }
    apiCalled.value = true;
    callingApi = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void submitReview() async {

    if (rateGuestsBehaviour.value == 0 ||
        rateHouseRules.value == 0 ||
        rateGuestsCommunication.value == 0) {
      showFailedToast("Please give all rating");
      return;
    }

    if (reviewBodyController.text.isEmpty) {
      showFailedToast("Write something");
      return;
    }

    double aveRate = (rateGuestsCommunication.value +
            rateHouseRules.value +
            rateGuestsBehaviour.value) /
        3;
    Component.progressDialog(context!);
    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      "guest_id": booking.value.guest.id,
      "stars": aveRate.toString(),
      "stars_detail[communication]": rateGuestsCommunication.value.toString(),
      "stars_detail[behaviour]": rateGuestsBehaviour.value.toString(),
      "stars_detail[house_rules]": rateHouseRules.value.toString(),
      "body": reviewBodyController.text,
      "booking_id": booking.value.id,
    });

    try {
      var response = await dio.post('api/review/guest', data: formData);
      if (response.data["success"]) {
        // .value = BookingModel.fromJson(response.data["data"]);
        // .refresh();
        // Constants.showToast("");
      } else {
        Constants.showToast(response.data["message"]);
      }
      Component.dismissDialog(context!);
    } catch (e) {
      Component.dismissDialog(context!);
      Constants.showToast(
          "response: ${DioExceptions.fromDioError(e as DioError).message}");
    }
  }
}
