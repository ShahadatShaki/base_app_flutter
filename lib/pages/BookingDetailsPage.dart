import 'package:base_app_flutter/component/ListingComponent.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';
import '../controller/BookingController.dart';

class BookingDetailsPage extends StatelessWidget {
  final BookingController controller = Get.put(BookingController());
  String id;
  late BuildContext context;
  late BookingModel item;

  BookingDetailsPage({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getSingleBooking(id);
    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Booking Details"),
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
        child: !controller.apiCalled.value
            ? Component.loadingView()
            : (controller.apiCalled.value &&
                    controller.booking.value.id.isNotEmpty)
                ? uiDesign(controller.booking.value)
                : Component.emptyView("Something Went Wrong",
                    "assets/animation/error_animation.json"));
  }

  uiDesign(BookingModel value) {
    item = value;

    return Container(
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          listingDetails(),
          const SizedBox(height: 24),
          line(),
          const SizedBox(height: 24),
          tripDetails(),
          const SizedBox(height: 24),
          line(),
          const SizedBox(height: 24),
          contactDetails(),
          const SizedBox(height: 24),
          line(),
          const SizedBox(height: 24),
          priceDetails(),



        ],
      ),
    );
  }

  listingDetails() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Component.loadImage(
            imageUrl: item.listing.getCoverImage(),
            height: 80,
            width: 80,
            cornerRadius: 8),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(children: [
                Expanded(
                  child: Text(
                    item.listing.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                ListingComponent.ratingView(item.listing)
              ]),
              const SizedBox(height: 4),
              Text(
                item.listing.address,
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.darkGray,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        )
      ],
    );
  }

  tripDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Trip Details"),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: ListingComponent.titleAndDetails(
                    title: "Check In",
                    details: item.listing.checkIn,
                    iconFront: AssetsName.clock,
                    iconBack: AssetsName.edit,
                    iconBackColor: AppColors.darkGray)),
            const SizedBox(width: 18),
            Expanded(
                child: ListingComponent.titleAndDetails(
                    title: "Check Out",
                    details: item.listing.checkOut,
                    iconFront: AssetsName.clock,
                    iconBack: AssetsName.edit,
                    iconBackColor: AppColors.darkGray)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: ListingComponent.titleAndDetails(
                    title: "Status",
                    details: item.status,
                    iconFront: AssetsName.clock)),
            const SizedBox(width: 18),
            Expanded(
                child: ListingComponent.titleAndDetails(
                    title: "Your request will expire in",
                    details: "Timer",
                    iconFront: AssetsName.clock)),
          ],
        ),
      ],
    );
  }

  sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.textColorBlack));
  }

  line() {
    return Container(
      width: double.infinity,
      height: 1,
      color: AppColors.lineColor,
    );
  }

  contactDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Contact Details"),
        const SizedBox(height: 12),
        Text(
          "Contact Number & Location will be provided once you \nConfirm &Pay",
          style: const TextStyle(
              fontSize: 14,
              color: AppColors.darkGray,
              fontWeight: FontWeight.w400),
        ),

      ],
    );
  }

  priceDetails() {
    return Column(
      
    );
  }
}
