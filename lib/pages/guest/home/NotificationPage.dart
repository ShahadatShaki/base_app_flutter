import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/NotificationController.dart';
import 'package:base_app_flutter/model/NotificationModel.dart';
import 'package:base_app_flutter/pages/ConversationPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class NotificationPage extends BaseStatelessWidget {
  final NotificationController controller = Get.put(NotificationController());
  late BuildContext context;

  NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getDataList();
    this.context = context;
    return Scaffold(
      appBar: Component.appbar(name: "Notification", showBackIcon: false),
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
    return Container(
        color: AppColors.backgroundColor,
        child: !controller.apiCalled.value
            ? Component.loadingView()
            : (controller.apiCalled.value && controller.dataList.isNotEmpty)
                ? uiDesign()
                : Component.emptyView(
                    "No Data Found", "assets/animation/empty_item.json"));
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

  cardDesign(int index, NotificationModel item) {
    return InkWell(
      onTap: () {
        // Get.to(() => ConversationPage(id: item.id.toString()));
      },
      child: Container(
        color: AppColors.backgroundColor,
        padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Row(
          children: [
            loadCircleImage(imageUrl: item.image, height: 45, width: 45),
            margin(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  margin(4),
                  Text(
                    item.body,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGray),
                  )
                ],
              ),
            ),
            margin(8),
            Text(
              Constants.calenderStingToString(item.createdAt, "hh:mm a"),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGray),
            )
          ],
        ),
      ),
    );
  }
}
