import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/pages/Webview.dart';
import 'package:base_app_flutter/pages/guest/PaymentWebview.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/DioExceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
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
  var bkashAction = "one-time".obs;

  @override
  void onInit() {
    partialPaymentController = TextEditingController();
    super.onInit();
  }

  getSingleBooking(String bookingId) async {
    error.value = false;

    if (callingApi) {
      return;
    }
    callingApi = true;

    this.id = bookingId;

    booking.value = await getBookingById(id);
    apiCalled.value = true;
    callingApi = false;
  }

  Future<dynamic> getBookingById(String id) async {
    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/booking/$id");
    try {
      var response = await get(uri);
      var res = ApiResponse<BookingModel>.fromJson(
          json.decode(response.body), (data) => BookingModel.fromJson(data));
      return res.data!;
    } catch (e) {
      error.value = true;
      print(e);
    }
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

      Component.progressDialog();

    }

    var client = http.Client();
    final queryParameters = {
      "amount": getUrl ? paymentAmount.value.toString() : "100",
      "provider": getUrl ? paymentGateway.value : "ssl",
      "action": bkashAction.value,
      "url": getUrl.toString(),
    };

    try {
      var uri = Uri.https(
          Urls.ROOT_URL_MAIN, "/api/booking/$id/payment", queryParameters);
      var response = await get(uri);
      if(getUrl)
        Component.dismissDialog();
      var res = ApiResponse<BookingModel>.fromJson(
          json.decode(response.body), (data) => BookingModel.fromJson(data));
      if (getUrl) {
        Get.off(() => PaymentWebview(url: res.data!.paymentUrl, title: "Payment"));
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
  void showAlert(String s) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            // title: Text("Test Title"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s),
                  ElevatedButton(
                      onPressed: () => {Get.back()},
                      child: Text("Close"))
                ],
              ),
            ),
          );
        });
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

  updateBooking({
    String bookingId = "",
    String status = "",
    String total_payable = "",
    String from = "",
    String listing_id = "",
    String to = "",
  }) async {
    Component.progressDialog();

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      'status': status,
      'total_payable': total_payable,
      'from': from,
      'listing_id': listing_id,
      'to': to,
      '_method': "patch",
    });

    try {
      var response = await dio.post('api/booking/${bookingId}', data: formData);
      print(response.data);
      Component.dismissDialog();
      getSingleBooking(bookingId);
    } catch (e) {
      Component.dismissDialog();
      print("response: " + DioExceptions.fromDioError(e as DioError).message);
    }
  }

  void createNewBookingForGuest(SearchOptions searchOptions) async {
    Component.progressDialog();

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      "listing_id": searchOptions.listingModel!.id,
      "guests": searchOptions.guestCount.toString(),
      "guest_id": booking.value.guest.id,
      "from": searchOptions.getCheckinDateForServer(),
      "to": searchOptions.getCheckoutDateForServer(),
      "status": "ACCEPTED"
    });

    try {
      var response = await dio.post('api/booking', data: formData);
      if (response.data["success"]) {
        booking.value = BookingModel.fromJson(response.data["data"]);
        booking.refresh();
        Constants.showToast("Booking created successfully");
      } else {
        Constants.showToast(response.data["message"]);
      }
      Component.dismissDialog();
    } catch (e) {
      Component.dismissDialog();
      Constants.showToast(
          "response: ${DioExceptions.fromDioError(e as DioError).message}");
    }
  }
}
