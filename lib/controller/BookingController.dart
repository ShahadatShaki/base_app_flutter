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

class BookingController extends GetxController {
  var booking = BookingModel().obs;
  var dataList = <BookingModel>[].obs;
  var id = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";
  var searchOptions = SearchOptions().obs;
  late ScrollController scrollController;
  bool hasMoreData = true;
  var page = 1;

  @override
  void onInit() {
    scrollController = ScrollController()
      ..addListener(() {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;
        double delta = 200.0; // or something else..
        if (maxScroll - currentScroll <= delta) {
          // whatever you determine here
          //.. load more

          if (hasMoreData && !callingApi) {
            page++;
            getMyBookingList();
          }
        }
      });
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

  bookingRequest() async {
    if (searchOptions.value.checkinDateCalender == null) {
      Constants.showToast("Select a date");
      return;
    }
    if (searchOptions.value.guestCount == 0) {
      Constants.showToast("Select guest");
      return;
    }

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      'listing_id': id,
      'guests': searchOptions.value.guestCount,
      'from': Constants.calenderToString(
          searchOptions.value.checkinDateCalender!, "yyyy-MM-dd"),
      'to': Constants.calenderToString(
          searchOptions.value.checkoutDateCalender!, "yyyy-MM-dd"),
    });

    print(dio);
    try {
      var response = await dio.post('api/booking', data: formData);
      Get.to(() => ExplorePage());
      print(response.data);
    } catch (e) {
      print("response: " + DioExceptions.fromDioError(e as DioError).message);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getMyBookingList() async {
    try {
      if (callingApi) {
        return;
      }

      callingApi = true;
      var client = http.Client();
      final queryParameters = {
        "page": page.toString(),
        "guest": "6",
      };

      var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/booking", queryParameters);
      var response = await client.get(uri, headers: await Urls.getHeaders());
      var res = ApiResponseList<BookingModel>.fromJson(
          json.decode(response.body), (data) => BookingModel.fromJson(data));
      if (page == 1) {
        dataList.clear();
      }
      dataList.value.addAll(res.data!);
      dataList.refresh();
      hasMoreData = res.data!.isNotEmpty;
      apiCalled.value = true;
      callingApi = false;
    } catch (e) {
      print(e);
    }
  }
}
