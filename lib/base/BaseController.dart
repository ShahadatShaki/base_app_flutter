import 'dart:convert';
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
        var res = json.decode(response.body);
        if (res["success"]) {
          return response;
        } else {
          error.value = true;
          errorMessage = res["message"];
          throw BadRequestException(errorMessage);
        }
      case 400:
        error.value = true;
        errorMessage = response.body.toString();
        throw BadRequestException(errorMessage);
      case 401:
        error.value = true;
        errorMessage =
            "Unauthorized, You do not have permission for this operation or Login again to continue";
        throw BadRequestException(errorMessage);
      case 403:
        error.value = true;
        errorMessage = response.body.toString();
        throw BadRequestException(errorMessage);
      case 500:
        error.value = true;
        errorMessage = "Internal Server Error";
        throw BadRequestException(errorMessage);
      default:
        error.value = true;
        errorMessage =
            "Error occurred while Communication with Server with StatusCode : ${response.statusCode}";
        throw BadRequestException(errorMessage);
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
