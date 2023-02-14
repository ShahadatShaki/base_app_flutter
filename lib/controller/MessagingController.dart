import 'dart:convert';

import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/model/MessagesModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class MessagingController extends GetxController {
  var conversation = ConversationModel().obs;
  var conversationDataList = <ConversationModel>[].obs;
  var messagesDataList = <MessagesModel>[].obs;
  var id = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";
  late ScrollController scrollController;
  late ScrollController messagesScrollController;
  bool hasMoreData = true;
  var inboxPage = 1;
  var conversationPage = 1;

  @override
  void onInit() {
    scrollController = ScrollController()
      ..addListener(() {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;
        double delta = 200.0; // or something else..
        if (maxScroll - currentScroll <= delta) {
          if (hasMoreData && !callingApi) {
            inboxPage++;
            getConversationList();
          }
        }
      });

    messagesScrollController = ScrollController()
      ..addListener(() {
        double maxScroll = messagesScrollController.position.maxScrollExtent;
        double currentScroll = messagesScrollController.position.pixels;
        double delta = 200.0; // or something else..
        if (maxScroll - currentScroll <= delta) {
          if (hasMoreData && !callingApi) {
            conversationPage++;
            print(conversationPage);
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

  void getConversationList() async {
    try {
      if (callingApi) {
        return;
      }

      callingApi = true;
      var client = http.Client();
      final queryParameters = {
        "page": inboxPage.toString(),
        "guest": "6",
      };

      var uri =
          Uri.https(Urls.ROOT_URL_MAIN, "/api/conversation", queryParameters);
      print(uri);
      var response = await client.get(uri, headers: await Urls.getHeaders());
      var res = ApiResponseList<ConversationModel>.fromJson(
          json.decode(response.body),
          (data) => ConversationModel.fromJson(data));
      if (inboxPage == 1) {
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

  void getMessagesList() async {
    try {
      if (callingApi) {
        return;
      }

      callingApi = true;
      var client = http.Client();
      final queryParameters = {
        "page": conversationPage.toString(),
      };

      var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/conversation/$id/messages",
          queryParameters);
      print(uri);
      var response = await client.get(uri, headers: await Urls.getHeaders());
      if (response.statusCode == 200) {
        var res = ApiResponseList<MessagesModel>.fromJson(
            json.decode(response.body), (data) => MessagesModel.fromJson(data));
        if (conversationPage == 1) {
          messagesDataList.clear();
        }
        messagesDataList.value.addAll(res.data!);
        messagesDataList.refresh();
        hasMoreData = res.data!.isNotEmpty;
      }

      apiCalled.value = true;
      callingApi = false;
    } catch (e) {
      print(e);
    }
  }
}
