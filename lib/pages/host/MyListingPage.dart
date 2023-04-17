import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/SmallListingItem.dart';
import 'package:base_app_flutter/controller/MyListingController.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../model/ListingModel.dart';
import '../../utility/AppColors.dart';

class MyListingPage extends BaseStatelessWidget {
  final MyListingController controller = Get.put(MyListingController());
  late BuildContext context;

  MyListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16,),
      child: ListView.builder(
        controller: controller.scrollController,
        itemCount: controller.dataList.value.length,
        // shrinkWrap: true,
        itemBuilder: (BuildContext c, int index) {
          return cardDesign(index, controller.dataList.value[index]);
        },
      ),
    );
  }

  cardDesign(int index, ListingModel item) {
    return InkWell(
      onTap: () {
        // searchOptions.listingModel = item;
        Get.back(result: item);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: SmallListingItem(listingModel: item),
      ),
    );
  }
}
