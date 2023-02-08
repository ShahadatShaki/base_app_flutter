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
import '../pages/BookingDetailsPage.dart';
import '../utility/DioExceptions.dart';
import '../utility/Urls.dart';

class ListingController extends GetxController {
  var listing = ListingModel().obs;
  var listingId = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";
  var searchOptions = SearchOptions().obs;
  late TextEditingController messageController;

  @override
  void onInit() {
    messageController = TextEditingController();
    super.onInit();
  }

  getData() async {
    if (callingApi) {
      return;
    }

    callingApi = true;

    var client = http.Client();
    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/listing/$listingId");
    var response = await client.get(uri, headers: await Urls.getHeaders());
    debugPrint(response.body);

    if (response.statusCode == 200) {
      var res = ApiResponse<ListingModel>.fromJson(
          json.decode(response.body), (data) => ListingModel.fromJson(data));
      listing.value = res.data!;
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
      'listing_id': listingId,
      'guests': searchOptions.value.guestCount,
      'message': messageController.text,
      'from': Constants.calenderToString(searchOptions.value.checkinDateCalender!,"yyyy-MM-dd"),
      'to': Constants.calenderToString(searchOptions.value.checkoutDateCalender!,"yyyy-MM-dd"),
    });

    try {
      var response = await dio.post('api/booking', data: formData);

      var responseBody = response.data;
      BookingModel m = BookingModel.fromJson(responseBody["data"]);
      print(responseBody);

      // var res = ApiResponse<BookingModel>.fromJson(
      //     json.decode(response.data.toString()), (data) => BookingModel.fromJson(data));
      //
      // BookingModel bookingModel = res.data!;
      // Get.to(()=> BookingDetailsPage(id: bookingModel.id!,));

      print(response.data);
    } catch (e) {
      // print("response: " + DioExceptions.fromDioError(e as DioError).message);
      print("response: "+e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    super.dispose();
  }
}