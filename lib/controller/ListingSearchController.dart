import 'dart:convert';

import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class ListingSearchController extends GetxController {
  var dataList = <ListingModel>[].obs;
  late SearchOptions searchOptions;
  var apiCalled = false.obs;
  late ScrollController scrollController;
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
        if (maxScroll - currentScroll <= delta) {
          // whatever you determine here
          //.. load more

          if (hasMoreData && !callingApi) {
            page++;
            getData();
          }
        }
      });
    super.onInit();
  }

  getData() async {
    print(page);

    callingApi = true;
    var client = http.Client();
    final queryParameters = {
      "page": page.toString(),
      "status": "active",
      "within": "10",
      "hotel": "1",
      "limit": "20",
      "address_name": searchOptions.name,
      "q": searchOptions.name,
      "guest": searchOptions.guestCount.toString(),
      "child": searchOptions.childCount.toString(),
      "infant": searchOptions.infantCount.toString(),
      "location": "${searchOptions.lat},${searchOptions.lng}",
      if (searchOptions.checkinDateCalender != null)
        "from": Constants.calenderToString(
            searchOptions.checkinDateCalender!, "yyyy-MM-dd"),
      if (searchOptions.checkoutDateCalender != null)
        "to": Constants.calenderToString(
            searchOptions.checkoutDateCalender!, "yyyy-MM-dd"),
    };

    var uri = Uri.https(Urls.ROOT_URL_MAIN, "/api/listing", queryParameters);
    print(uri);

    var response = await client.get(uri, headers: await Urls.getHeaders());
    debugPrint(response.body);

    var res = ApiResponseList<ListingModel>.fromJson(
        json.decode(response.body), (data) => ListingModel.fromJson(data));
    if (page == 1) {
      dataList.clear();
    }
    dataList.value.addAll(res.data!);
    dataList.refresh();
    hasMoreData = res.data!.isNotEmpty;
    apiCalled.value = true;
    callingApi = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
