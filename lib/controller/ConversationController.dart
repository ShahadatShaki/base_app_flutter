import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/model/MessagesModel.dart';
import 'package:base_app_flutter/utility/DioExceptions.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:pusher_client/pusher_client.dart';

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class ConversationController extends BaseController {
  var conversation = ConversationModel().obs;
  var dataList = <MessagesModel>[].obs;
  var id = "";
  late ScrollController scrollController;
  var page = 1;
  late TextEditingController textEditingController;

  @override
  void onInit() {
    connectPusher();

    textEditingController = TextEditingController();
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
      var response = await get(uri);
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

  getSingleConversation() async {
    var client = http.Client();
    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/conversation/$id");
    var response = await client.get(uri, headers: await Urls.getHeaders());
    print(response.body);

    if (response.statusCode == 200) {
      var res = ApiResponse<ConversationModel>.fromJson(
          json.decode(response.body),
          (data) => ConversationModel.fromJson(data));
      conversation.value = res.data!;

      getBooking();
    } else {
      // errorMessage = response.
    }
  }

  void connectPusher() async {
    PusherOptions options = PusherOptions(
        host: Urls.SOCKET_SERVER,
        wsPort: 6001,
        // wssPort: 6001,
        // cluster: "ws-"+Urls.PUSHER_APP_CLUSTER+".pusher.com",
        encrypted: false);

    PusherClient pusher =
        PusherClient(Urls.PUSHER_APP_KEY, options, autoConnect: false);

    await pusher.connect();

    pusher.onConnectionStateChange((state) {
      print(
          "previousState: ${state?.previousState}, currentState: ${state?.currentState}");
    });

    pusher.onConnectionError((error) {
      print("error: ${error?.message}");
    });

    Channel channel = pusher.subscribe("user.${SharedPref.userId}");
    channel.bind("message.received", (event) {
      // var inbox = ConversationModel.fromJson(json.decode(event!.data!));
      var message =
          MessagesModel.fromJson(json.decode(event!.data!)["message"]);

      // if (chat.guest.isBlocked || chat.host.isBlocked)
      //   finish()
      //
      //
      if (message.senderId == conversation.value.guest.id ||
          message.senderId == conversation.value.host.id) {
        dataList.insert(0, message);
        dataList.refresh();

        if (message.type == "0") {
          getBooking();
          // page = 1;
          // getMessagesList();
        }
      }
    });

    // channel.e
  }

  void sendMessage() async {
    if (textEditingController.text.isEmpty) {
      return;
    }

    MessagesModel messagesModel = MessagesModel();
    messagesModel.body = textEditingController.text;
    messagesModel.senderId = SharedPref.userId;
    dataList.insert(0, messagesModel);
    dataList.refresh();

    Dio dio = await Urls.getDio();
    var formData = FormData.fromMap({
      'conversation_id': id,
      'body': textEditingController.text,
    });

    textEditingController.clear();
    try {
      var response = await dio.post('api/message', data: formData);
      print(response.data);
    } catch (e) {
      print("response: " + DioExceptions.fromDioError(e as DioError).message);
    }
  }

  void getBooking() async {
    var client = http.Client();

    final queryParameters = {
      "page": page.toString(),
      "guest": conversation.value.guest.id,
      "host": conversation.value.host.id,
      "limit": "1"
    };

    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/booking", queryParameters);
    var response = await client.get(uri, headers: await Urls.getHeaders());
    var res = ApiResponseList<BookingModel>.fromJson(
        json.decode(response.body), (data) => BookingModel.fromJson(data));

    conversation.value.booking = res.data?[0];
    conversation.refresh();
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
    super.onResumed();

    if (conversation.value.id.isNotEmpty) {
      getBooking();
    }
  }
}
