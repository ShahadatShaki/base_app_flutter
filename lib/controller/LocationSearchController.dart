import 'dart:convert';

import 'package:base_app_flutter/model/LocationModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;

import '../base/ApiResponseList.dart';
import '../utility/DioExceptions.dart';
import '../utility/Urls.dart';

class LocationSearchController extends GetxController {
  var dataList = <LocationModel>[].obs;
  var apiCalled = false.obs;
  late ScrollController scrollController;
  late TextEditingController searchEtController;
  var isSearching = false;

  var page = 1;
  bool callingApi = false;
  bool hasMoreData = true;

  @override
  void onInit() {
    searchEtController = TextEditingController();

    scrollController = ScrollController()
      ..addListener(() {
        double maxScroll = scrollController.position.maxScrollExtent;
        double currentScroll = scrollController.position.pixels;
        double delta = 200.0; // or something else..
        if (maxScroll - currentScroll <= delta) {
          // whatever you determine here
          //.. load more
        }
      });
    super.onInit();
  }

  getData(String text) async {
    var client = http.Client();
    final queryParameters = {"q": text, "page": page.toString()};

    var uri = Uri.https(
        Urls.ROOT_URL_MAIN, "/api/popular-locations", queryParameters);
    print(uri);

    var response = await client.get(uri, headers: await Urls.getHeaders());
    print(response.body);

    if (response.statusCode == 200) {
      var res = ApiResponseList<LocationModel>.fromJson(
          json.decode(response.body), (data) => LocationModel.fromJson(data));

      if (page == 1) {
        dataList.clear();
      }
      dataList.value.addAll(res.data!);
      dataList.refresh();
    }

    apiCalled.value = true;
  }

  submitBill() async {
    Dio dio = await Urls.getDio();

    var selfie = "".obs;
    var bill = "".obs;
    var formData = FormData.fromMap({
      'merchant_id': '202',
      'amount': '200',
      'review': "",
      'image_meta': "",
      'selfie_meta': "",
      'public': "true",
    });

    formData.files.add(MapEntry(
        "image", await MultipartFile.fromFile(bill.value, filename: 'image')));
    formData.files.add(MapEntry("selfies[0]",
        await MultipartFile.fromFile(selfie.value, filename: 'image')));

    try {
      var response = await dio.post('/api/v1/user/bills/claim', data: formData);
      print(response);
    } catch (e) {
      print("response: " + DioExceptions.fromDioError(e as DioError).message);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchEtController.dispose();
  }
}
