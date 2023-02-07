import 'dart:convert';

import 'package:base_app_flutter/base/ApiResponse.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class ListingController extends GetxController {
  var listing = ListingModel().obs;
  var listingId  = "";
  var apiCalled = false.obs;
  bool callingApi = false;
  String errorMessage = "";

  @override
  void onInit() {
    super.onInit();
  }

  getData() async {

    if(callingApi) {
      return;
    }

    callingApi = true;



    var client = http.Client();
    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/listing/$listingId");
    var response = await client.get(uri, headers: await Urls.getHeaders());
    debugPrint(response.body);

    if(response.statusCode == 200) {
      var res = ApiResponse<ListingModel>.fromJson(
          json.decode(response.body), (data) => ListingModel.fromJson(data));
      listing.value = res.data!;
    }else{
      // errorMessage = response.
    }

    apiCalled.value = true;
    callingApi = false;


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
