import 'dart:async';

import 'package:base_app_flutter/model/LocationModel.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../controller/LocationSearchController.dart';
import '../../model/SearchOptions.dart';
import '../../utility/AppColors.dart';

class LocationSearch extends StatelessWidget {
  LocationSearchController controller = Get.put(LocationSearchController());
  SearchOptions searchOptions;

  LocationSearch({required this.searchOptions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getData("");
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Select Location"),
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        searchView(),
        Obx(() => showListOrEmptyView()) // merchantCardDesign()
      ],
    );
  }

  showListOrEmptyView() {
    return Expanded(
      child: Column(
        children: [
          Visibility(
              visible: !controller.apiCalled.value,
              // visible: false,
              child: Component.loadingView()),
          Visibility(
            visible: controller.apiCalled.value &&
                controller.dataList.value.isNotEmpty,
            // visible: false,
            child: Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.dataList.value.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext c, int index) {
                  return cardDesign(controller.dataList.value[index]);
                },
              ),
            ),
          ),
          Visibility(
              visible: controller.dataList.value.isEmpty &&
                  controller.apiCalled.value,
              child: Component.emptyView(
                  "No Data Found", "assets/animation/empty_item.json")),
        ],
      ),
    );
  }

  cardDesign(LocationModel item) {
    var borderRadius = 8.0;
    return InkWell(
      onTap: () {
        searchOptions.name = item.getName()!;
        searchOptions.lat = item.lat;
        searchOptions.lng = item.lng;

        Get.back(result: searchOptions);
      },
      child: Container(
        color: AppColors.separator,
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Column(
          children: [
            Row(
              children: [
                Component.showIcon(
                    name: AssetsName.ic_location, color: AppColors.appColor),
                SizedBox(
                  width: 12,
                ),
                Text(
                  item.getName(),
                )
              ],
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 1,
              color: AppColors.lineColor,
            )
          ],
        ),
      ),
    );
  }

  searchView() {
    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: AppColors.separator),
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: TextField(
        controller: controller.searchEtController,
        onChanged: textChanged,
        decoration:
            InputDecoration(hintText: "Search", border: InputBorder.none),
      ),
    );
  }

  Timer? timeHandle;

  void textChanged(String val) {
    controller.isSearching = true;
    if (timeHandle != null) {
      timeHandle!.cancel();
    }

    timeHandle = Timer(Duration(seconds: 1), () {
      controller.page = 1;
      controller.hasMoreData = true;
      controller.getData(val);
    });
  }
}
