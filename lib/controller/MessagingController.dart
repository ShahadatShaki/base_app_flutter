import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
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

class MessagingController extends GetxController {
  var conversation = ConversationModel().obs;
  var conversationDataList = <ConversationModel>[].obs;
  var id = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";
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
          if (hasMoreData && !callingApi) {
            page++;
            getConversationList();
          }
        }
      });
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
      var res = ApiResponse<ConversationModel>.fromJson(
          json.decode(response.body), (data) => ConversationModel.fromJson(data));
      conversation.value = res.data!;
    } else {
      // errorMessage = response.
    }
    apiCalled.value = true;
    callingApi = false;
  }

  bookingRequest() async {


    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      'listing_id': id,
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

  void getConversationList() async {
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

      var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/conversation", queryParameters);
      print(uri);
      var response = await client.get(uri, headers: await Urls.getHeaders());
      var res = ApiResponseList<ConversationModel>.fromJson(
          json.decode(response.body), (data) => ConversationModel.fromJson(data));
      if (page == 1) {
        conversationDataList.clear();
      }
      conversationDataList.value.addAll(res.data!);
      conversationDataList.refresh();
      hasMoreData = res.data!.isNotEmpty;
      apiCalled.value = true;
      callingApi = false;
    } catch (e) {
      print(e);
    }
  }
}
