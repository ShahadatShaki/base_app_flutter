import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/controller/MyListingController.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../model/ListingModel.dart';
import '../../model/SearchOptions.dart';
import '../../utility/AppColors.dart';

class MyListingPage extends BaseStatelessWidget {
  final MyListingController controller = Get.put(MyListingController());
  SearchOptions searchOptions;
  late BuildContext context;

  MyListingPage({required this.searchOptions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.searchOptions = searchOptions;
    controller.getData();
    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Select Listing"),
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Obx(() => showListOrEmptyView()) // merchantCardDesign()
        ],
      ),
    );
  }

  showListOrEmptyView() {
    return Expanded(
      child: Container(
        child: !controller.apiCalled.value
            ? Component.loadingView()
            : (controller.apiCalled.value && controller.dataList.isNotEmpty)
                ? uiDesign()
                : controller.error.value
                    ? Component.emptyView(
                        controller.errorMessage, AssetsName.errorAnimation)
                    : Component.emptyView(
                        "No Data Found",
                        "assets/animation/empty_item.json",
                      ),
      ),
    );
  }

  uiDesign() {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.dataList.value.length,
      // shrinkWrap: true,
      itemBuilder: (BuildContext c, int index) {
        return cardDesign(index, controller.dataList.value[index]);
      },
    );
  }

  cardDesign(int index, ListingModel item) {
    return InkWell(
      onTap: () {
        searchOptions.listingModel = item;
        Get.back(result: searchOptions);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Row(
          children: [
            loadImage(imageUrl: item.images[0].url, width: 100, height: 70),
            margin(16),
            Expanded(
                child: Text(
              item.title,
              maxLines: 3,
              style: Component.textStyle16bkw500(),
            ))
          ],
        ),
      ),
    );
  }
}
