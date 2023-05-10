import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';

import '../utility/Urls.dart';

class NotificationClickController extends BaseController {
  @override
  void onInit() {
    super.onInit();
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

  Future<dynamic> conversationWithHostAndGuestId(String host, String guest) async {

    final queryParameters = {
      "host": host,
      "guest": guest,
    };

    var uri = Uri.https(
        Urls.ROOT_URL_MAIN, "/api/conversation/find", queryParameters);

    try {
      var response = await get(uri);
      var res = ApiResponse<ConversationModel>.fromJson(
          json.decode(response.body), (data) => ConversationModel.fromJson(data));
      return res.data!;
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> getConversationIdFromBooking(String id) async {

    BookingModel bookingModel = await getBookingById(id);
    ConversationModel conversationModel = await conversationWithHostAndGuestId(bookingModel.host.id, bookingModel.guest.id);

    return conversationModel;
  }
}
