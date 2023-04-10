import 'dart:convert';

import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class BookingController extends BaseController {
  var booking = BookingModel().obs;
  var dataList = <BookingModel>[].obs;
  var id = "";
  var searchOptions = SearchOptions().obs;
  late ScrollController scrollController;
  var page = 1;

  var isTermsChecked = false.obs;

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
      var key = "guest";
      if (SharedPref.isHost) {
        key = "host";
      }
      final queryParameters = {
        "page": page.toString(),
        key: SharedPref.userId,
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
      error.value = true;
      apiCalled.value = true;
      callingApi = false;
      errorMessage = "Something went wrong";
      print(e);
    }
  }
}
