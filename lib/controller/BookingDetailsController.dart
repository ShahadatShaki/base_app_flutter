import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/pages/Webview.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/DioExceptions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../utility/Urls.dart';

class BookingDetailsController extends BaseController {
  var booking = BookingModel().obs;
  var bookingPayment = BookingModel().obs;
  var dataList = <BookingModel>[].obs;
  var id = "";
  var paymentGateway = "bkash".obs;
  var paymentOption = "full".obs;
  var paymentAmount = 0.obs;
  var page = 1;

  late TextEditingController partialPaymentController;

  var isTermsChecked = false.obs;

  @override
  void onInit() {
    partialPaymentController = TextEditingController();
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

  void getPaymentUrl(bool getUrl) async {
    if (getUrl) {
      var amount = paymentAmount.value;

      if (amount < 15) {
        Constants.showFailedToast("Pay minimum 15 BDT");
        return;
      }

      if (booking.value.paid == 0) {
        if (amount < bookingPayment.value.minimumPayableAmount.toInt()) {
          Constants.showFailedToast(
              "Pay minimum ${bookingPayment.value.minimumPayableAmount} BDT");
          return;
        }
      }

      var due = booking.value.totalPayable - (booking.value.paid + amount);
      if (0 < due && due < 16) {
        Constants.showFailedToast("Due amount can not be less then 15 BDT");
        return;
      }

      if (due < 0) {
        Constants.showFailedToast("Amount can not be more then total payable");
        return;
      }
    }

    var client = http.Client();
    final queryParameters = {
      "amount": getUrl ? paymentAmount.value.toString() : "100",
      "provider": getUrl ? paymentGateway.value : "ssl",
      "action": "payment",
      "url": getUrl.toString(),
    };

    try {
      var uri = Uri.https(
          Urls.ROOT_URL_MAIN, "/api/booking/$id/payment", queryParameters);
      var response = await client.get(uri, headers: await Urls.getHeaders());
      var res = ApiResponse<BookingModel>.fromJson(
          json.decode(response.body), (data) => BookingModel.fromJson(data));
      if (getUrl) {
        Get.to(() => WebviewPage(url: res.data!.paymentUrl, title: "Payment"));
      } else {
        bookingPayment.value = res.data!;
        bookingPayment.value.minimumPayableAmount = 100;
        // booking.value.amount = res.data?.amount;
        showPartialPaymentTextField();
        bookingPayment.refresh();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showPartialPaymentTextField() {
    if (booking.value.paid == 0) {
      partialPaymentController.text =
          bookingPayment.value.minimumPayableAmount.toString();
    } else {
      partialPaymentController.text =
          (booking.value.totalPayable - booking.value.paid).toString();
    }
  }

  void setPartialOrFullAmount() {
    if (paymentOption.value == "full") {
      paymentAmount.value = booking.value.totalPayable - booking.value.paid;
    } else {
      paymentAmount.value = int.parse(partialPaymentController.text.toString());
    }
  }

  void amountChanged(String value) {
    setPartialOrFullAmount();
  }

  updateBooking({String bookingId = "", String status = ""}) async {

    Component.progressDialog(context!);
    var body = jsonEncode(<String, String>{
      'status': status,
    });

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      'status': status,
      '_method': "patch",
    });

    try {
      var response = await dio.post('api/booking/${bookingId}', data: formData);
      print(response.data);

      Component.dismissDialog(context!);
      getSingleBooking(bookingId);
    } catch (e) {
      Component.dismissDialog(context!);
      print("response: " + DioExceptions.fromDioError(e as DioError).message);
    }


  }
}
