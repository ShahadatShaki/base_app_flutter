import 'package:base_app_flutter/component/ListingComponent.dart';
import 'package:base_app_flutter/controller/BookingDetailsController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/pages/ListingDetailsPage.dart';
import 'package:base_app_flutter/pages/guest/PaymentOverviewPage.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';

class BookingDetailsPage extends StatelessWidget with Component {
  final BookingDetailsController controller =
      Get.put(BookingDetailsController());
  String id;
  late BuildContext context;
  late BookingModel booking;

  BookingDetailsPage({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getSingleBooking(id);
    this.context = context;
    controller.context = context;
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
    booking = value;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listingDetails(),
            lineHorizontal(margin: const EdgeInsets.only(top: 24, bottom: 24)),
            tripDetails(),
            lineHorizontal(margin: const EdgeInsets.only(top: 24, bottom: 24)),
            contactDetails(),
            lineHorizontal(margin: const EdgeInsets.only(top: 24, bottom: 24)),
            priceDetails(),
            lineHorizontal(margin: const EdgeInsets.only(top: 24, bottom: 24)),
            actionButton(),
            margin(16),
            if (SharedPref.isHost) spatialOfferButton()
          ],
        ),
      ),
    );
  }

  listingDetails() {
    return InkWell(
      onTap: () {
        Get.to(() => ListingDetailsPage(
              listingId: booking.listing.id,
            ));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          loadImage(
              imageUrl: booking.listing.getCoverImage(),
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
                      booking.listing.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  ListingComponent.ratingView(booking.listing)
                ]),
                const SizedBox(height: 4),
                Text(
                  booking.listing.address,
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
                    details:
                        booking.fromShortStrForShow(format: "dd MMM, yyyy"),
                    iconFront: AssetsName.clock,
                    iconBack: AssetsName.edit,
                    iconBackColor: AppColors.darkGray)),
            const SizedBox(width: 18),
            Expanded(
                child: ListingComponent.titleAndDetails(
                    title: "Check Out",
                    details: booking.toShortStrForShow(format: "dd MMM, yyyy"),
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
                    details: booking.status,
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
        const Text(
          "Contact Number & Location will be provided once you \nConfirm &Pay",
          style: TextStyle(
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
            "BDT ${booking.listing.price}  x ${booking.getTotalNights()} nights",
            "৳${booking.totalPayable + booking.getAllDiscount()}"),
        // margin(16),
        // priceDetailsSection("Cleaning fee", "৳1200"),
        // margin(16),
        // priceDetailsSection("Service fee", "৳1200"),
        // margin(16),
        // priceDetailsSection("Taxes", "৳1200"),
        margin(16),
        priceDetailsSection("Discount", "৳${booking.getAllDiscount()}"),
        lineHorizontal(margin: const EdgeInsets.only(top: 24, bottom: 8)),
        duePaidSection("Total Payable", "৳${booking.totalPayable}"),
        duePaidSection("Paid", "৳${booking.paid}"),
        duePaidSection("Due", "৳${booking.totalPayable - booking.paid}"),
        if (SharedPref.isHost)
          duePaidSection("Service Fee", "৳${booking.serviceFee}"),
        if (SharedPref.isHost)
          duePaidSection(
              "You Will Earn", "৳${booking.totalPayable - booking.serviceFee}"),
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
    return Column(
      children: [
        margin(16),
        Row(
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
        ),
      ],
    );
  }

  actionButton() {
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
        (booking.isRequested() ||
                    booking.isAccepted() ||
                    booking.isRejected()) &&
                !booking.isExpire
            ? approveRejectButton()
            : margin(0);
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
          Get.to(() => PaymentOverviewPage(id: booking.id));
        },
        child: buttonText(buttonTitle: "Confirm And Pay", height: 50));
  }

  spatialOfferButton() {
    return ElevatedButton(
        style: buttonStyle(backgroundColor: Colors.green),
        onPressed: () {
          spatialOfferBottomSheet();
        },
        child:
            buttonText(buttonTitle: "Spatial Offer".toUpperCase(), height: 40));
  }

  void spatialOfferBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Offer New Price',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColorBlack),
                    ),
                    margin(16),
                    Container(
                      width: double.infinity,
                      child: Text(
                        'Current Total Payable: ${booking.totalPayable}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColorBlack),
                      ),
                    ),
                    margin(24),
                    TextField(
                        // controller: controller.firstNameController,
                        decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: const Text("Offer New Price"),
                      labelStyle: TextStyle(color: AppColors.darkGray),
                    )),
                    margin(24),
                    TextField(
                        enabled: false,
                        // controller: controller.firstNameController,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: const Text("Check In and Check Out Date"),
                          hintText:
                              "Click here to pick check in and check out date",
                          labelStyle: TextStyle(color: AppColors.darkGray),
                        )),
                    margin(24),
                    TextField(
                        enabled: false,
                        // controller: controller.firstNameController,
                        decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          label: const Text("Listing"),
                          hintText: "Click here to select listing",
                          labelStyle: TextStyle(color: AppColors.darkGray),
                        )),


                    // ElevatedButton(
                    //   child: const Text('Close BottomSheet'),
                    //   onPressed: () => Get.back(),
                    // ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        color: AppColors.darkGray,
                        alignment: Alignment.center,
                        child: Text("Listing", style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16, fontWeight: FontWeight.bold
                        ),),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: 40,
                        color: AppColors.appColor,
                        alignment: Alignment.center,
                        child: Text("Listing", style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16, fontWeight: FontWeight.bold
                        ),),
                      )),
                ],
              ),

            ],
          ),
        );
      },
    );
  }

  approveRejectButton() {
    return ElevatedButton(
        style: buttonStyle(),
        onPressed: () {
          acceptRejectDialog();
        },
        child: buttonText(
            buttonTitle: booking.isRequested()
                ? "Approve or Reject".toUpperCase()
                : "Update Status".toUpperCase(),
            height: 50));
  }

  void acceptRejectDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  booking.listing.title,
                  maxLines: 1,
                  style: Component.textStyle16bkw500(),
                ),
                margin(8),
                Text(
                  "${booking.status} • ${booking.fromToStrForShow()} • ${booking.totalGuest} Adults • ${booking.totalPayable}",
                  style: Component.textStyle14bkw400(),
                ),
                margin(16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Component.dismissDialog(context!);

                        controller.updateBooking(
                            bookingId: booking.id, status: "rejected");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "REJECT",
                          style: Component.textStyle14bkw400(
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkGray),
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    TextButton(
                      onPressed: () {
                        Component.dismissDialog(context);
                        controller.updateBooking(
                            bookingId: booking.id, status: "accepted");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "ACCEPT",
                          style: Component.textStyle14bkw400(
                              fontWeight: FontWeight.w500,
                              color: AppColors.appColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
