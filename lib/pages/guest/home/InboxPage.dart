import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/BookingController.dart';
import 'package:base_app_flutter/controller/MessagingController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/pages/BookingDetailsPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
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
        child: !controller.apiCalled.value
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
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: Row(
          children: [
            Component.loadCircleImage(imageUrl: item.host.image.url, height: 50, width: 50),
           const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.host.firstName, style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColorBlack
                  ),),
                  const SizedBox(height: 4),
                  Text("${item.lastMessage.senderId== SharedPref.userId?"You: ":""}${item.lastMessage.body}", maxLines: 1, style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColorBlack
                  ),),
                  const SizedBox(height: 4),
                  Text("${item.booking.fromToStrForShow()} * ${item.booking.listing.title}", maxLines: 1, style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGray
                  ),),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(Constants.totalDays(DateTime.now())>Constants.totalDays(Constants.stingToCalender(item.lastMessage.createdAt))?
            Constants.calenderStingToString(item.lastMessage.createdAt, "MMM dd")
              :             Constants.calenderStingToString(item.lastMessage.createdAt, "hh:mm a")
              , style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColorBlack
            ),),
          ],
        ),
      ),
    );
  }
}