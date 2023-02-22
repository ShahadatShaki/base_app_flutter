import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/ListingComponent.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/pages/ListingDetailsPage.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';
import '../controller/BookingController.dart';

class BookingDetailsPage extends BaseStatelessWidget {
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

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listingDetails(),
            lineHorizontal(margin: EdgeInsets.only(top: 24, bottom: 24)),
            tripDetails(),
            lineHorizontal(margin: EdgeInsets.only(top: 24, bottom: 24)),
            contactDetails(),
            lineHorizontal(margin: EdgeInsets.only(top: 24, bottom: 24)),
            priceDetails(),
            lineHorizontal(margin: EdgeInsets.only(top: 24, bottom: 24)),
            confirmAndPayButton()
          ],
        ),
      ),
    );
  }

  listingDetails() {
    return InkWell(
      onTap: () {
        Get.to(() => ListingDetailsPage(
              listingId: item.listing.id,
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          loadImage(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle("Price Details"),
        margin(16),
        priceDetailsSection("BDT 1200 taka x 5 nights", "৳1200"),
        margin(16),
        priceDetailsSection("Cleaning fee", "৳1200"),
        margin(16),
        priceDetailsSection("Service fee", "৳1200"),
        margin(16),
        priceDetailsSection("Taxes", "৳1200"),
        margin(16),
        priceDetailsSection("Discount", "৳1200"),
        lineHorizontal(margin: EdgeInsets.only(top: 24, bottom: 24)),
        duePaidSection("Total Payable", "৳1200"),
        margin(16),
        duePaidSection("Paid", "৳1200"),
        margin(16),
        duePaidSection("Due", "৳1200"),
      ],
    );
  }

  priceDetailsSection(String title, String description) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGray)),
        ),
        Text(description,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColorBlack)),
      ],
    );
  }

  duePaidSection(String title, String description) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorBlack)),
        ),
        Text(description,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColorBlack)),
      ],
    );
  }

  confirmAndPayButton() {
    return item.isExpire()
        ? TextButton(onPressed: () {}, child: Text("Book Again"))
        : Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
                  ),
                  Expanded(
                    child: RichText(
                      text:  TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text:
                                  'Upon licking on Confirm And Pay, I agree to The ',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColorBlack)),
                          TextSpan(
                              text: 'Terms & Conditions,',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print("Terms & Conditions");
                                },
                              style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textColorBlack,
                                  decoration: TextDecoration.underline)),
                        ],
                      ),
                    ),

                    // Text(
                    //     "Upon licking on Confirm And Pay, I agree to The Terms & Conditions, Privacy Policy and Refund Policy of Travela."),
                  ),
                ],
              ),
              margin(16),
              ElevatedButton(
                  style: buttonStyle(),
                  onPressed: () {},
                  child: buttonText(buttonTitle: "Book Again", height: 50))
            ],
          );
  }
}
