import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/pages/ConversationPage.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../pages/BookingDetailsPage.dart';
import '../utility/Urls.dart';

class ListingController extends BaseController {
  var listing = ListingModel().obs;
  var listingId = "";
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
    if (searchOptions.value.checkinDateCalender == null) {
      Constants.showToast("Select a date");
      return;
    }
    if (searchOptions.value.guestCount == 0) {
      Constants.showToast("Select guest");
      return;
    }

    Component.progressDialog(context!);
    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      'listing_id': listingId,
      'guests': searchOptions.value.guestCount,
      'message': messageController.text,
      'from': Constants.calenderToString(
          searchOptions.value.checkinDateCalender!, "yyyy-MM-dd"),
      'to': Constants.calenderToString(
          searchOptions.value.checkoutDateCalender!, "yyyy-MM-dd"),
    });

    try {
      var response = await dio.post('api/booking', data: formData);

      Component.dismissDialog(context!);
      if (response.data["success"]) {
        BookingModel m = BookingModel.fromJson(response.data["data"]);
        if (m.status.toLowerCase() == "accepted") {
          Get.off(() => BookingDetailsPage(id: m.id));
        } else {
          findConversation(m);
        }
      } else {
        Constants.showToast(response.data["message"]);
      }
    } catch (e) {
      Constants.showToast(e.toString());
      print("response: " + e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    messageController.dispose();
    super.dispose();
  }

  void findConversation(BookingModel m) async {
    var client = http.Client();

    final queryParameters = {
      "host": listing.value.host.id,
      "guest": SharedPref.userId,
    };

    var uri = Uri.https(
        Urls.ROOT_URL_MAIN, "/api/conversation/find", queryParameters);
    var response = await client.get(uri, headers: await Urls.getHeaders());

    if (response.statusCode == 200) {
      var res = ApiResponse<ConversationModel>.fromJson(
          json.decode(response.body),
          (data) => ConversationModel.fromJson(data));

      Get.off(() => ConversationPage(
            id: res.data!.id,
          ));
    } else {
      // errorMessage = response.
    }
  }
}
