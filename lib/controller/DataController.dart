import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../model/DataModel.dart';
import '../utility/Urls.dart';

class DataController extends GetxController {
  var notifications = <DataModel>[].obs;
  var apiCalled = false.obs;
  late ScrollController scrollController;
  late TextEditingController searchEtController;
  var isSearching = false;

  var page = 1;
  bool callingApi = false;
  bool hasMoreData = true;


  @override
  void onInit() {
    scrollController = ScrollController()
      ..addListener(() {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;
        double delta = 200.0; // or something else..
        if ( maxScroll - currentScroll <= delta) { // whatever you determine here
          //.. load more
        }
      });
    getData(page);
    super.onInit();
  }

  getData(int page) async {
    var client = http.Client();
    var uri = Uri.https(
        Urls.ROOT_URL_MAIN, "api/v1/user/notifications");

    var response = await client.get(uri, headers: await Urls.getHeaders());

    var res = ApiResponseList<DataModel>.fromJson(
        json.decode(response.body), (data) => DataModel.fromJson(data));
    notifications.value = res.data!;

    apiCalled.value = true;
  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchEtController.dispose();
  }
}
