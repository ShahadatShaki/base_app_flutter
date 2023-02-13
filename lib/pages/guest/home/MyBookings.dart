import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/BookingController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/pages/BookingDetailsPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
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
        Get.to(() => BookingDetailsPage(id: item.id!.toString()));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Component.loadCircleImage(
                    imageUrl:
                        item.images!.isNotEmpty ? item.images![0].url! : "",
                    width: 50,
                    height: 50),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "#${item.id!}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.darkGray),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.listing!.title!,
                        style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textColorBlack,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          "${Constants.calenderToString(item.calenderFrom(), "dd-MMM")} - -${Constants.calenderToString(item.calenderTo(), "dd-MMM")}"),
                      const SizedBox(height: 4),
                      Text(
                        "Address: ${item.listing!.address!}",
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.darkGray),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Total: ${item.totalPayable}",
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.appColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Paid: ${item.paid}",
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textColorBlack),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Due: ${int.parse(item.totalPayable!) - int.parse(item.paid!)}",
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.textColorBlack),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Status: ${item.status == "Confirmed" ? "Paid, Enjoy your trip" : item.status}",
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.darkGray),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}