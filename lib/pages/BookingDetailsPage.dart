import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/ListingComponent.dart';
import 'package:base_app_flutter/controller/BookingDetailsController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/pages/ListingDetailsPage.dart';
import 'package:base_app_flutter/pages/guest/PaymentOverviewPage.dart';
import 'package:base_app_flutter/utility/AppStrings.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';
import '../controller/BookingController.dart';

class BookingDetailsPage extends StatelessWidget with Component {
  final BookingDetailsController controller = Get.put(BookingDetailsController());
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
            actionButton()
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
                    details: item.fromShortStrForShow(format: "dd MMM, yyyy"),
                    iconFront: AssetsName.clock,
                    iconBack: AssetsName.edit,
                    iconBackColor: AppColors.darkGray)),
            const SizedBox(width: 18),
            Expanded(
                child: ListingComponent.titleAndDetails(
                    title: "Check Out",
                    details: item.toShortStrForShow(format: "dd MMM, yyyy"),
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
        priceDetailsSection(
            "BDT ${item.listing.price} taka x ${item.getTotalNights()} nights",
            "৳${item.totalPayable + item.getAllDiscount()}"),
        // margin(16),
        // priceDetailsSection("Cleaning fee", "৳1200"),
        // margin(16),
        // priceDetailsSection("Service fee", "৳1200"),
        // margin(16),
        // priceDetailsSection("Taxes", "৳1200"),
        margin(16),
        priceDetailsSection("Discount", "৳${item.getAllDiscount()}"),
        lineHorizontal(margin: const EdgeInsets.only(top: 24, bottom: 24)),
        duePaidSection("Total Payable", "৳${item.totalPayable}"),
        margin(16),
        duePaidSection("Paid", "৳${item.paid}"),
        margin(16),
        duePaidSection(
            "Due", "৳${item.totalPayable - item.paid}"),
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

  // confirmAndPayButton() {
  //   return item.isExpire
  //       ? ElevatedButton(
  //           style: buttonStyle(),
  //           onPressed: () {},
  //           child: buttonText(buttonTitle: "Book Again", height: 50))
  //       :
  //   Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Checkbox(
  //                   value: controller.isTermsChecked.value,
  //                   onChanged: (value) {
  //                     controller.isTermsChecked.value = value ?? false;
  //                   },
  //                 ),
  //                 Expanded(
  //                     child: Html(
  //                   data: AppStrings.termsAndCondition,
  //
  //                   // style: {
  //                   //   "p": Style(
  //                   //     border: Border(bottom: BorderSide(color: Colors.grey)),
  //                   //     padding: const EdgeInsets.all(16),
  //                   //     fontSize: FontSize(30),
  //                   //   ),
  //                   // },
  //                   onLinkTap: (url, context, attributes, element) {
  //                     Constants.showToast(url ?? "");
  //                   },
  //                 )),
  //               ],
  //             ),
  //             margin(16),
  //             ElevatedButton(
  //                 style: buttonStyle(),
  //                 onPressed: () {},
  //                 child: buttonText(buttonTitle: "Confirm And Pay", height: 50))
  //           ],
  //         );
  // }

  actionButton() {
    var booking = item;
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
          Get.to(()=> PaymentOverviewPage(id: item.id));
        },
        child: buttonText(buttonTitle: "Confirm And Pay", height: 50));
  }
}
