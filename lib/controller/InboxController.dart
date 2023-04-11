import 'dart:convert';

import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/model/MessagesModel.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class InboxController extends BaseController {
  var conversation = ConversationModel().obs;
  var conversationDataList = <ConversationModel>[].obs;
  var messagesDataList = <MessagesModel>[].obs;
  var id = "";
  late ScrollController scrollController;
  late ScrollController messagesScrollController;
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
    if (callingApi) {
      return;
    }

    callingApi = true;

    var key = "guest";
    if (SharedPref.isHost) {
      key = "host";
    }
    final queryParameters = {
      "page": inboxPage.toString(),
      key: SharedPref.userId,
    };

    try {
      var uri =
          Uri.https(Urls.ROOT_URL_MAIN, "/api/conversation", queryParameters);
      var response = await get(uri);
      var res = ApiResponseList<ConversationModel>.fromJson(
          json.decode(response.body),
          (data) => ConversationModel.fromJson(data));
      if (inboxPage == 1) {
        conversationDataList.clear();
      }
      conversationDataList.value.addAll(res.data!);
      conversationDataList.refresh();
      hasMoreData = res.data!.isNotEmpty;
    } catch (e) {
      print(e);
    }
    apiCalled.value = true;
    callingApi = false;
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
      var response = await get(uri);
      var res = ApiResponseList<MessagesModel>.fromJson(
          json.decode(response.body), (data) => MessagesModel.fromJson(data));
      if (conversationPage == 1) {
        messagesDataList.clear();
      }
      messagesDataList.value.addAll(res.data!);
      messagesDataList.refresh();
      hasMoreData = res.data!.isNotEmpty;
      apiCalled.value = true;
      callingApi = false;
    } catch (e) {
      print(e);
    }
  }
}
