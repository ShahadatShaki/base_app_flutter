import 'dart:async';

import 'package:base_app_flutter/controller/ListingDetailsController.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../component/Component.dart';
import '../../model/ListingModel.dart';
import '../../utility/AppColors.dart';
import 'PickCalenderPage.dart';

class BookingRequestPage extends StatelessWidget {
  final ListingController controller =
      Get.put(ListingController());
  String listingId;
  ListingModel listing;
  late BuildContext context;

  BookingRequestPage({required this.listingId, required this.listing, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.listingId = listingId;
    controller.getData();
    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Booking Request"),
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hostDetails(),
              const SizedBox(height: 24),
              const Text("Tell me your preferred date",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorBlack)),

              const SizedBox(height: 24),
              Obx(() => checkinCheckoutLayout(controller.searchOptions.value)),
              const SizedBox(height: 24),
              Obx(() => guestCountLayout(controller.searchOptions.value)),
              const SizedBox(height: 24),
              messageInputBox(controller.searchOptions.value),
              const SizedBox(height: 24),
              bookNowButton()
            ],
          ),
        ),
      ),
    );
  }

  hostDetails() {
    return Row(
      children: [
        Component.loadCircleImage(
            imageUrl: listing.host!.image!.url!, width: 70, height: 70),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Hello!",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appColor)),
            SizedBox(height: 8),
            Text("Thanks for getting in touch",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColorBlack)),
          ],
        ),
      ],
    );
  }

  checkinCheckoutLayout(SearchOptions searchOptions) {

    return Container(
      decoration: BoxDecoration(
        boxShadow: [Component.dropShadow()],
      ),
      child: Card(
        shape: Component.roundShape(),
        elevation: 0,
        child: InkWell(
          onTap: () async {
            var data = await Get.to(
                    () => PickCalenderPage(searchOptions: searchOptions));
            if (data != null) {
              controller.searchOptions.value = data;
              controller.searchOptions.refresh();
            }
          },
          child: Container(
            height: 70,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Component.showIcon(
                  name: AssetsName.calender,
                  size: 24,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Check In - Check Out",
                          style: TextStyle(
                              color: AppColors.darkGray,
                              fontSize:
                              searchOptions.getCheckinCheckoutShortDate().isEmpty
                                  ? 16
                                  : 12),
                        ),
                        SizedBox(
                            height:
                            searchOptions.getCheckinCheckoutShortDate().isNotEmpty
                                ? 4
                                : 0),
                        searchOptions.getCheckinCheckoutShortDate().isNotEmpty
                            ? Text(
                          searchOptions.getCheckinCheckoutShortDate(),
                          style: const TextStyle(
                              color: AppColors.textColorBlack, fontSize: 16),
                        )
                            : SizedBox(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  guestCountLayout(SearchOptions searchOptions) {

    return Container(
      decoration: BoxDecoration(
        boxShadow: [Component.dropShadow()],
      ),
      child: Card(
        shape: Component.roundShape(),
        elevation: 0,
        child: InkWell(
          onTap: ()  {
            Component.showGuestCountBottomSheet(context, controller.searchOptions);
          },
          child: Container(
            height: 70,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Component.showIcon(
                  name: AssetsName.guest,
                  size: 24,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Guest",
                          style: TextStyle(
                              color: AppColors.darkGray,
                              fontSize:
                              searchOptions.getGuestCounts().isEmpty ? 16 : 12),
                        ),
                        SizedBox(
                            height: searchOptions.getGuestCounts().isEmpty ? 0 : 4),
                        searchOptions.getGuestCounts().isNotEmpty
                            ? Text(
                          searchOptions.getGuestCounts(),
                          style: const TextStyle(
                              color: AppColors.textColorBlack, fontSize: 16),
                        )
                            : SizedBox(),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  messageInputBox(SearchOptions searchOptions) {

    return Container(
      decoration: BoxDecoration(
        boxShadow: [Component.dropShadow()],
      ),
      child: Card(
        shape: Component.roundShape(),
        elevation: 0,
        child: TextField(
          controller: controller.messageController,
          minLines: 4,
          maxLines: 100,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Ask me anything",
            contentPadding: EdgeInsets.all(16),
            fillColor: AppColors.appColor,
          ),
        ),
      ),
    );
  }

  bookNowButton() {
    return TextButton(
      style: Component.textButtonStyle(radius: 8),
      onPressed: () {
            controller.bookingRequest();
      },
      child: Component.textButtonText(buttonTitle: "Request for book"),
    );
  }





}
