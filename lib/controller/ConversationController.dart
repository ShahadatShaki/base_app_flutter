import 'dart:convert';

import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/model/MessagesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class ConversationController extends GetxController {
  var conversation = ConversationModel().obs;
  var dataList = <MessagesModel>[].obs;
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
            getMessagesList();
          }
        }
      });

    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void getMessagesList() async {
    try {
      if (callingApi) {
        return;
      }

      callingApi = true;
      var client = http.Client();
      final queryParameters = {
        "page": page.toString(),
      };

      var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/conversation/$id/messages",
          queryParameters);
      print(uri);
      var response = await client.get(uri, headers: await Urls.getHeaders());
      if (response.statusCode == 200) {
        var res = ApiResponseList<MessagesModel>.fromJson(
            json.decode(response.body), (data) => MessagesModel.fromJson(data));
        if (page == 1) {
          dataList.clear();
        }
        dataList.value.addAll(res.data!);
        dataList.refresh();
        hasMoreData = res.data!.isNotEmpty;
      }

      apiCalled.value = true;
      callingApi = false;
    } catch (e) {
      print(e);
    }
  }
}
