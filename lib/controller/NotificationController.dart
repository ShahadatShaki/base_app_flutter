import 'dart:convert';

import 'package:base_app_flutter/model/NotificationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class NotificationController extends GetxController {
  var dataList = <NotificationModel>[].obs;
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
            getDataList();
          }
        }
      });

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getDataList() async {
    try {
      if (callingApi) {
        return;
      }

      callingApi = true;
      var client = http.Client();
      final queryParameters = {
        "page": page.toString(),
      };

      var uri =
          Uri.https(Urls.ROOT_URL_MAIN, "/api/notification", queryParameters);
      print(uri);
      var response = await client.get(uri, headers: await Urls.getHeaders());
      print(response.body);
      var res = ApiResponseList<NotificationModel>.fromJson(
          json.decode(response.body),
          (data) => NotificationModel.fromJson(data));

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
