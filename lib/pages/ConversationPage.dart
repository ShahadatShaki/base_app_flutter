import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/MessagingController.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/model/MessagesModel.dart';
import 'package:base_app_flutter/pages/BookingDetailsPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ConversationPage extends StatelessWidget {
  final MessagingController controller = Get.put(MessagingController());
  late BuildContext context;
  String id;

  ConversationPage({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.id = id;
    controller.getMessagesList();
    this.context = context;
    return Scaffold(
      appBar: Component.appbar(name: "Chat Page", showBackIcon: false),
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
            : (controller.apiCalled.value &&
                    controller.messagesDataList.isNotEmpty)
                ? uiDesign()
                : Component.emptyView(
                    "No Data Found", "assets/animation/empty_item.json"));
  }

  uiDesign() {
    return ListView.builder(
      controller: controller.messagesScrollController,
      itemCount: controller.messagesDataList.length,
      reverse: true,
      // shrinkWrap: true,
      itemBuilder: (BuildContext c, int index) {
        return cardDesign(index, controller.messagesDataList[index]);
      },
    );
  }

  cardDesign(int index, MessagesModel item) {
    return InkWell(
      onTap: () {
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: Text(item.body),
      ),
    );
  }
}
