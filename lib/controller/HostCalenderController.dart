import 'dart:convert';

import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/model/BlockDatesModel.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/DioExceptions.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class HostCalenderController extends BaseController {
  var blockDatesObjList = <BlockDatesModel>[].obs;
  var blockDatesList = <DateTime>[].obs;
  var selectedDates = <DateTime>[].obs;
  var id = "";
  late ScrollController scrollController;
  var inboxPage = 1;
  var listing = ListingModel().obs;
  var amountController = TextEditingController();
  var calenderOptionOnAvailable = true.obs;

  var calenderData = false.obs;

  @override
  void onInit() {
    apiCalled.value = false;
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getBlockDateList() async {
    calenderData.value = false;
    final queryParameters = {
      "listing": listing.value.id,
      // "listing": "9",
    };

    try {
      var uri = Uri.https(Urls.ROOT_URL_MAIN,
          "/api/listing-price-and-restriction", queryParameters);
      var response = await get(uri);
      var res = ApiResponseList<BlockDatesModel>.fromJson(
          json.decode(response.body), (data) => BlockDatesModel.fromJson(data));

      if (res.success) {
        blockDatesList.clear();
        blockDatesObjList.clear();

        blockDatesObjList.addAll(res.data);

        for (var i = 0; i < blockDatesObjList.length; i++) {
          blockDatesList.add(blockDatesObjList[i].dateCalendar());
        }

        blockDatesList.refresh();
        calenderData.value = true;

        hasMoreData = res.data.isNotEmpty;
      } else {
        Constants.showToast(res.message);
      }
    } catch (e) {
      error.value = true;
      print(e);
    }
  }

  getMyListing() async {
    if (callingApi) {
      return;
    }
    error.value = false;

    callingApi = true;
    final queryParameters = {
      "page": "1",
      "host": SharedPref.userId,
      "limit": "20",
    };

    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/listing", queryParameters);

    try {
      var response = await get(uri);
      var res = ApiResponseList<ListingModel>.fromJson(
          json.decode(response.body), (data) => ListingModel.fromJson(data));

      if (res.data.length > 0) {
        listing.value = res.data.first;
        getBlockDateList();
      }
    } catch (e) {
      error.value = true;
      errorMessage = e.toString();
      print(e);
    }
    apiCalled.value = true;
    callingApi = false;
  }

  void updateCalenderSettings() async {
    if (calenderOptionOnAvailable.value) {
       unblockDates();
      updatePrice();
    } else {
      blockDates();
    }

  }

  void blockDates() async {
    // Component.progressDialog(context!);

    List<String> dates = [];
    for (var i = 0; i < selectedDates.length; i++) {
      dates.add(Constants.calenderToString(selectedDates[i], "yyyy-MM-dd"));
    }

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      "listing": listing.value.id,
      "total_count": "1",
      "dates[]": dates,
    });

    try {
      var response = await dio.post('api/restriction', data: formData);
      if (response.data["success"]) {
        selectedDates.clear();
        getBlockDateList();
        Constants.showToast("Success");
      } else {
        Constants.showToast(response.data["message"]);
      }
      // Component.dismissDialog(context!);
    } catch (e) {
      // Component.dismissDialog(context!);
      Constants.showToast(
          "response: ${DioExceptions.fromDioError(e as DioError).message}");
    }
  }

  void unblockDates() async {
    List<String> dates = [];
    for (var i = 0; i < selectedDates.length; i++) {
      for (var j = 0; j < blockDatesObjList.length; j++) {
        if (Constants.totalDays(selectedDates[i]) ==
            Constants.totalDays(blockDatesList[j]) && blockDatesObjList[j].price.isEmpty) {

          dates.add(blockDatesObjList[j].id);
          unblock(blockDatesObjList[j].id);
        }
      }
    }
  }

  void unblock(String id) async {
    Dio dio = await Urls.getDio();
    // var formData = FormData.fromMap({
    //   // "listing": listing.value.id,
    //   // "total_count": "1",
    //   "dates[]": dates,
    // });

    try {
      var response = await dio.delete('api/restriction/$id');
      if (response.data["success"]) {
        selectedDates.clear();
        getBlockDateList();
      } else {
        Constants.showToast(response.data["message"]);
      }
      // Component.dismissDialog(context!);
    } catch (e) {
      // Component.dismissDialog(context!);
      Constants.showToast(
          "response: ${DioExceptions.fromDioError(e as DioError).message}");
    }
  }

  void updatePrice() async {
    // Component.progressDialog(context!);

    List<String> dates = [];
    for (var i = 0; i < selectedDates.length; i++) {
      dates.add(Constants.calenderToString(selectedDates[i], "yyyy-MM-dd"));
    }

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      "listing_id": listing.value.id,
      "price": amountController.text,
      "dates[]": dates,
    });

    try {
      var response = await dio.post('api/custom-listing-price', data: formData);
      if (response.data["success"]) {
        selectedDates.clear();
        getBlockDateList();
        Constants.showToast("Success");
      } else {
        Constants.showToast(response.data["message"]);
      }
      // Component.dismissDialog(context!);
    } catch (e) {
      // Component.dismissDialog(context!);
      Constants.showToast(
          "response: ${DioExceptions.fromDioError(e as DioError).message}");
    }
  }
}
