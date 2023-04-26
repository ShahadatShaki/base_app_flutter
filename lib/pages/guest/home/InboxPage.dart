import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/InboxController.dart';
import 'package:base_app_flutter/model/ConversationModel.dart';
import 'package:base_app_flutter/pages/ConversationPage.dart';
import 'package:base_app_flutter/pages/guest/WriteReviewHostPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class InboxPage extends BaseStatelessWidget {
  final InboxController controller = Get.put(InboxController());
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
      color: AppColors.backgroundColor,
      child: !controller.apiCalled.value
          ? Component.loadingView()
          : (controller.apiCalled.value &&
                  controller.conversationDataList.isNotEmpty)
              ? uiDesign()
              : controller.error.value
                  ? Component.emptyView(
                      controller.errorMessage, AssetsName.errorAnimation)
                  : Component.emptyView(
                      "No Data Found",
                      "assets/animation/empty_item.json",
                    ),
    );
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
    String arrivingTime = "";
    if (item.booking.status == "4" || item.booking.isConfirmed()) {
      arrivingTime = item.booking.getArrivingTime();
    }

    return InkWell(
      onTap: () {
        Get.to(() => ConversationPage(id: item.id.toString()))
            ?.then((value) => controller.getConversationList());
      },
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
        child: Row(
          children: [
            loadCircleImage(
                imageUrl: SharedPref.isHost
                    ? item.guest.image.url
                    : item.host.image.url,
                height: 50,
                width: 50),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (arrivingTime.isNotEmpty)
                    Text(
                      item.booking.getArrivingTime(),
                      style: TextStyle(
                          color: AppColors.greenAppColor, fontSize: 12),
                    ),
                  Text(
                    SharedPref.isHost
                        ? item.guest.firstName
                        : item.host.firstName,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColorBlack),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.lastMessage.senderId == SharedPref.userId ? "You: " : ""}${item.lastMessage.body}",
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColorBlack),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.booking.fromToStrForShow()} * ${item.booking.listing.title}",
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGray),
                  ),
                  if (arrivingTime != "Awaiting guest review" ||
                      arrivingTime == "Awaiting host review")
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: TextButton(
                        style: Component.textButtonStyle(
                            radius: 4, backgroundColor: AppColors.appColor),
                        onPressed: () {
                          Get.to(()=> WriteReviewHostPage(bookingModel: item.booking));
                        },
                        child: buttonText(
                            fontSize: 12,
                            buttonTitle: "Write Review",
                            height: 25),
                      ),
                    ),
                  if (!SharedPref.isHost &&
                      item.booking.is_listing_available &&
                      !item.booking.isExpire &&
                      item.booking.isAccepted())
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: TextButton(
                        style: Component.textButtonStyle(
                            radius: 4, backgroundColor: AppColors.appColor),
                        onPressed: () {

                        },
                        child: buttonText(
                            fontSize: 12,
                            buttonTitle: "Confirm Now",
                            height: 25),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(
              Constants.totalDays(DateTime.now()) >
                      Constants.totalDays(
                          Constants.stingToCalender(item.lastMessage.createdAt))
                  ? Constants.calenderStingToString(
                      item.lastMessage.createdAt, "MMM dd")
                  : Constants.calenderStingToString(
                      item.lastMessage.createdAt, "hh:mm a"),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorBlack),
            ),
          ],
        ),
      ),
    );
  }
}
