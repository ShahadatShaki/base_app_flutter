import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/ConversationController.dart';
import 'package:base_app_flutter/model/MessagesModel.dart';
import 'package:base_app_flutter/pages/BookingDetailsPage.dart';
import 'package:base_app_flutter/pages/ListingDetailsPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class ConversationPage extends BaseStatelessWidget {
  final ConversationController controller = Get.put(ConversationController());
  late BuildContext context;
  String id;

  ConversationPage({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.id = id;
    controller.getSingleConversation();
    controller.getMessagesList();
    this.context = context;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Obx(() => Component.appbarDark(
              name: controller.conversation.value.host.firstName,
              showBackIcon: true))),
      backgroundColor: AppColors.black,
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return SafeArea(
      child: Column(
        children: [
          Obx(() => bookingView()),
          Expanded(child: Obx(() => showListOrEmptyView())),
          messageFieldAndSendButton(),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Obx(() => actionButton()),
          )
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
    return item.type == "0"
        ? systemGeneratedMessage(index, item)
        : item.senderId == SharedPref.userId
            ? currentUserMessage(index, item)
            : otherUserMessage(index, item);
  }

  systemGeneratedMessage(int index, MessagesModel item) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: AppColors.chatMessageBg),
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          Component.showIcon(name: AssetsName.guest, size: 15),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              item.body,
              style: const TextStyle(fontSize: 12, color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  currentUserMessage(int index, MessagesModel item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 100),
        Flexible(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.chatMessageBg),
            margin: const EdgeInsets.only(top: 8, left: 100, right: 16),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Text(
              item.body,
              style: const TextStyle(fontSize: 16, color: AppColors.white),
            ),
          ),
        ),
      ],
    );
  }

  otherUserMessage(int index, MessagesModel item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 16),
        loadCircleImage(
            imageUrl: controller.conversation.value.host.image.url,
            width: 25,
            height: 25),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColors.chatMessageBg),
            margin: const EdgeInsets.only(top: 8, right: 100),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            child: Text(
              item.body,
              style: const TextStyle(fontSize: 16, color: AppColors.white),
            ),
          ),
        ),
      ],
    );
  }

  messageFieldAndSendButton() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin:
                const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: AppColors.chatMessageTfBg),
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: TextField(
                controller: controller.textEditingController,
                style: TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                    hintText: "Write message",
                    hintStyle:
                        TextStyle(color: AppColors.chatMessageTfHintColor),
                    border: InputBorder.none),
              ),
            ),
          ),
        ),
        InkWell(
            onTap: () {
              controller.sendMessage();
            },
            child: Component.showIcon(
                name: AssetsName.send, color: AppColors.white, size: 30)),
        margin(16),
      ],
    );
  }

  bookingView() {
    var item = controller.conversation.value.booking;

    return item.id.isEmpty
        ? margin(0)
        : Container(
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    loadImage(
                        imageUrl:
                            item.images.length > 0 ? item.images[0].url : "",
                        height: 30,
                        width: 30),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.to(() =>
                              ListingDetailsPage(listingId: item.listing.id));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            item.listing.title,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: Component.textButtonStyle(),
                      onPressed: () {
                        visitBookingDetailsPage(item.id);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: const Text('Details',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${item.status} • ${item.fromToStrForShow()} • ${item.totalGuest} Adults • ${item.totalPayable}",
                  style: const TextStyle(color: AppColors.white),
                ),
              ],
            ),
          );
  }

  actionButton() {
    var booking = controller.conversation.value.booking;
    if (booking.id.isNotEmpty) {
      return SharedPref.userId == booking.guest.id
          ?
          //Guest View
          //<editor-fold desc="Book Again">
          booking.isConfirmed()
              ? Constants.totalDays(booking.calenderCheckout()) <=
                      Constants.totalDays(DateTime.now())
                  ? bookAgain()
                  : margin(0)
              //</editor-fold>
              : booking.isPartial()
                  ? confirmAndPayButton()
                  : booking.isAccepted() && !booking.isExpire
                      ? confirmAndPayButton()
                      : booking.isRequested() && !booking.isExpire
                          ? margin(0)
                          : bookAgain()
          :
          //Host View
          margin(0);
    } else {
      return margin(0);
    }
  }

  bookAgain() {
    return ElevatedButton(
        style: buttonStyle(),
        onPressed: () {},
        child: buttonText(buttonTitle: "Book Again", height: 50));
  }

  confirmAndPayButton() {
    return ElevatedButton(
        style: buttonStyle(),
        onPressed: () {
          visitBookingDetailsPage(controller.conversation.value.booking.id);
        },
        child: buttonText(buttonTitle: "Confirm And Pay", height: 50));
  }

  void visitBookingDetailsPage(String id) {
    Get.to(() => BookingDetailsPage(id: id))
        ?.then((value) => controller.getBooking());
  }
}
