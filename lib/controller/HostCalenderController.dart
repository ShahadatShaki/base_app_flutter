import 'dart:convert';

import 'package:base_app_flutter/base/BaseController.dart';
import 'package:base_app_flutter/model/BlockDatesModel.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:get/state_manager.dart';

import '../base/ApiResponseList.dart';
import '../utility/Urls.dart';

class HostCalenderController extends BaseController {
  var blockDatesObjList = <BlockDatesModel>[].obs;
  var blockDatesList = <DateTime>[].obs;
  var selectedDates = <DateTime>[].obs;
  var id = "";
  late ScrollController scrollController;
  var inboxPage = 1;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getBlockDateList() async {
    if (callingApi) {
      return;
    }

    callingApi = true;

    final queryParameters = {
      "listing": "9",
    };

    try {
      var uri =
          Uri.https(Urls.ROOT_URL_MAIN, "/api/listing-price-and-restriction", queryParameters);
      var response = await get(uri);
      var res = ApiResponseList<BlockDatesModel>.fromJson(
          json.decode(response.body), (data) => BlockDatesModel.fromJson(data));

      if (res.success) {
        blockDatesList.clear();
        blockDatesObjList.clear();

        blockDatesObjList.addAll(res.data);

        for (var i = 0; i < blockDatesObjList.length; i++) {
          blockDatesList.add(blockDatesObjList[i].dateCalendar());
        }

        blockDatesList.refresh();
        hasMoreData = res.data.isNotEmpty;
      } else {
        Constants.showToast(res.message);
      }
    } catch (e) {
      error.value = true;
      print(e);
    }
    apiCalled.value = true;
    callingApi = false;
  }
}
