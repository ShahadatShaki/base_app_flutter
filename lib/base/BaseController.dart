import 'dart:io';

import 'package:base_app_flutter/utility/Urls.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BaseController extends GetxController {
  var apiCalled = false.obs;
  var error = false.obs;
  bool callingApi = false;
  String errorMessage = "";
  bool hasMoreData = true;

  Future<dynamic> get(Uri uri) async {
    var client = http.Client();
    var responseJson;
    try {
      var response = await client.get(uri, headers: await Urls.getHeaders());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw BadRequestException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw BadRequestException(response.body.toString());
      case 500:
        throw BadRequestException("Internal Server Error");
      default:
        throw BadRequestException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}

class BadRequestException implements Exception {
  final _message;

  BadRequestException([this._message]);

  String toString() {
    return "$_message";
  }
}
