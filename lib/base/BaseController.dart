import 'dart:convert';
import 'dart:io';

import 'package:base_app_flutter/utility/Urls.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BaseController extends GetxController {
  var apiCalled = false.obs;
  var error = false.obs;
  bool callingApi = false;
  String errorMessage = "";
  bool hasMoreData = true;
  BuildContext? context;

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

  Future<dynamic> post({Uri? uri, dynamic body}) async {
    var client = http.Client();
    var responseJson;
    try {
      var response =
          await client.post(uri!, headers: await Urls.getHeaders(), body: body);
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
          errorMessage = res["message"];
          throw BadRequestException(errorMessage);
        }
      case 400:
        errorMessage = response.body.toString();
        throw BadRequestException(errorMessage);
      case 401:
        errorMessage =
            "Unauthorized, You do not have permission for this operation or Login again to continue";
        throw BadRequestException(errorMessage);
      case 403:
        errorMessage = response.body.toString();
        throw BadRequestException(errorMessage);
      case 500:
        errorMessage = "Internal Server Error";
        throw BadRequestException(errorMessage);
      default:
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
