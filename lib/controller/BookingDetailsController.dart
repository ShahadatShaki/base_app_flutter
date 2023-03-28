import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/pages/Webview.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../utility/Urls.dart';

class BookingDetailsController extends GetxController {
  var booking = BookingModel().obs;
  var dataList = <BookingModel>[].obs;
  var id = "";
  var paymentGateway = "".obs;
  var paymentAmount = 0.obs;
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

      paymentAmount.value =
          int.parse(booking.value.totalPayable) - int.parse(booking.value.paid);
    } else {
      // errorMessage = response.
    }
    apiCalled.value = true;
    callingApi = false;
  }

  var provider = "";

  void getPaymentUrl(bool getUrl) async {
    var client = http.Client();
    final queryParameters = {
      "amount": paymentAmount.toString(),
      "provider": provider,
      "agreement": "true",
      "url": getUrl.toString(),
    };

    var uri = Uri.https(
        Urls.ROOT_URL_MAIN, "/api/booking/$id/payment", queryParameters);
    var response = await client.get(uri, headers: await Urls.getHeaders());
    var res = ApiResponse<BookingModel>.fromJson(
        json.decode(response.body), (data) => BookingModel.fromJson(data));
    if (getUrl) {
      Get.to(()=> WebviewPage(url: res.data!.paymentUrl, title: "Payment"));
    } else {
      booking.value.amount = res.data?.amount;
      booking.refresh();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
