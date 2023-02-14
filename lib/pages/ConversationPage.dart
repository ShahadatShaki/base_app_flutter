import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/ConversationController.dart';
import 'package:base_app_flutter/model/MessagesModel.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ConversationPage extends StatelessWidget {
  final ConversationController controller = Get.put(ConversationController());
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
      backgroundColor: AppColors.black,
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: Obx(() => showListOrEmptyView())),
          bottomView(),
        ],
      ),
    );
  }

  showListOrEmptyView() {
    return Container(
        color: AppColors.black,
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
      reverse: true,
      // shrinkWrap: true,
      itemBuilder: (BuildContext c, int index) {
        return cardDesign(index, controller.dataList[index]);
      },
    );
  }

  cardDesign(int index, MessagesModel item) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: Text(item.body),
      ),
    );
  }

  bottomView() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 24),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: AppColors.separator),
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              // controller: controller.searchEtController,
              // onChanged: textChanged,
              decoration:
                  InputDecoration(hintText: "Search", border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}
