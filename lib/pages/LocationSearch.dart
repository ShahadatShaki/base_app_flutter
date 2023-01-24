import 'package:base_app_flutter/model/DataModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/Component.dart';
import '../controller/DataController.dart';
import '../utility/AppColors.dart';

class LocationSearch extends StatelessWidget {
  final DataController controller = Get.put(DataController());

  LocationSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                controller.notifications.value.isNotEmpty,
            // visible: false,
            child: Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.notifications.value.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext c, int index) {
                  return cardDesign(controller.notifications.value[index]);
                },
              ),
            ),
          ),
          Visibility(
              visible: controller.notifications.value.isEmpty &&
                  controller.apiCalled.value,
              child: Component.emptyView(
                  "No Data Found", "assets/empty_item.json")),
        ],
      ),
    );
  }

  cardDesign(DataModel item) {
    var borderRadius = 8.0;
    return Container(
      color: item.isNew! ? AppColors.lightestPurple : AppColors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          CachedNetworkImage(
            imageUrl: item.image!,
            height: 80,
            width: 80,
            placeholder: (context, url) =>
                Image.asset("assets/generic_placeholder.png"),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.message!),
              const SizedBox(height: 4),
              Text(item.createdAt!),
            ],
          ))
        ],
      ),
    );
  }

  searchView() {
    return Container(
      margin: EdgeInsets.all(24),
      child: TextField(
        decoration: InputDecoration(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),

            fillColor: AppColors.separator),
      ),
    );
  }
}