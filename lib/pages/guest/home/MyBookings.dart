import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/BookingController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/pages/ListingDetailsPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class MyBookings extends StatelessWidget {
  final BookingController controller = Get.put(BookingController());
  late BuildContext context;

  MyBookings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getMyBookingList();
    this.context = context;
    return Scaffold(
      appBar: Component.appbar(name: "My Trips", showBackIcon: false),
      backgroundColor: AppColors.white,
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return SafeArea(
      child: Obx(() => showListOrEmptyView()),
    );
  }

  showListOrEmptyView() {
    return Expanded(
      child: Container(
        color: AppColors.separator,
          child: !controller.apiCalled.value
              ? Component.loadingView()
              : (controller.apiCalled.value && controller.dataList.isNotEmpty)
                  ? uiDesign()
                  : Component.emptyView(
                      "No Data Found", "assets/animation/empty_item.json")),
    );
  }

  uiDesign() {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.dataList.length,
      // shrinkWrap: true,
      itemBuilder: (BuildContext c, int index) {
        return cardDesign(index, controller.dataList[index]);
      },
    );
  }

  cardDesign(int index, BookingModel item) {
    return InkWell(
      onTap: () {
        Get.to(() => ListingDetailsPage(listingId: item.id!.toString()));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.listing!.title!),
            Text(item.from! + item.to!),
          ],
        ),
      ),
    );
  }
}
