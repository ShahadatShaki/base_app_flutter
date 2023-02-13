import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/BookingController.dart';
import 'package:base_app_flutter/controller/MessagingController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/pages/BookingDetailsPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class InboxPage extends StatelessWidget {
  final MessagingController controller = Get.put(MessagingController());
  late BuildContext context;

  InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   controller.getConversationList();
    this.context = context;
    return Scaffold(
      appBar: Component.appbar(name: "Inbox", showBackIcon: false),
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
        color: AppColors.separator,
        child: controller.apiCalled.value
            ? Component.loadingView()
            : (controller.apiCalled.value && controller.conversationDataList.isNotEmpty)
                ? uiDesign()
                : Component.emptyView(
                    "No Data Found", "assets/animation/empty_item.json"));
  }

  uiDesign() {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.conversationDataList.length,
      // shrinkWrap: true,
      itemBuilder: (BuildContext c, int index) {
        return cardDesign(index, controller.conversationDataList[index]);
      },
    );
  }

  cardDesign(int index, ConversationModel item) {
    return InkWell(
      onTap: () {
        Get.to(() => BookingDetailsPage(id: item.id.toString()));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
        child: Row(
          children: [
            Component.loadCircleImage(imageUrl: item.host.image.url, height: 50, width: 50),
            Text(item.id),
          ],
        ),
      ),
    );
  }
}
