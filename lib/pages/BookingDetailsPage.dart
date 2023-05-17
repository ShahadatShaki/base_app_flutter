import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/GuestCountBottomSheet.dart';
import 'package:base_app_flutter/component/ListingComponent.dart';
import 'package:base_app_flutter/component/TextFieldHelper.dart';
import 'package:base_app_flutter/controller/BookingDetailsController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/pages/ListingDetailsPage.dart';
import 'package:base_app_flutter/pages/guest/PaymentOverviewPage.dart';
import 'package:base_app_flutter/pages/guest/PickCalenderPage.dart';
import 'package:base_app_flutter/pages/host/MyListingPage.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';

class BookingDetailsPage extends BaseStatelessWidget {
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
    return isCallButtonEnable()
        ? booking.guest.id == SharedPref.userId
            ? contactDetailsForGuest()
            : contactDetailsForHost()
        : Column(
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

  bool isCallButtonEnable() {
    return (booking.isConfirmed() || booking.isPartial()) &&
        Constants.totalDays(booking.calenderCheckout()) + 1 >=
            Constants.totalDays(DateTime.now());
  }

  contactDetailsForGuest() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(children: [
                Text(
                  booking.host.firstName,
                  style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textColorBlack,
                      fontWeight: FontWeight.w400),
                ),
                // HtmlWidget(
                //   booking.host.phone,
                //   textStyle: const TextStyle(
                //       fontSize: 14,
                //       color: AppColors.textColorBlack,
                //       fontWeight: FontWeight.w400),
                // ),
              ]),
            ),
            showIcon(name: AssetsName.call, size: 30),
          ],
        ),
      ],
    );
  }

  contactDetailsForHost() {
    return Column(
      children: [],
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
        // booking.isConfirmed()
        //     ? Constants.totalDays(booking.calenderCheckout()) <=
        //             Constants.totalDays(DateTime.now())
        //         ?
        // bookAgain()
        //         : margin(0)
        //     //</editor-fold>
        //     : booking.isPartial()
        //         ? confirmAndPayButton()
        //         : booking.isAccepted() && !booking.isExpire
        //             ? confirmAndPayButton()
        //             : booking.isRequested() && !booking.isExpire
        //                 ? margin(0)
        //                 : bookAgain()
        booking.actionButton() == BookingModel.ACTION_PAY
            ? confirmAndPayButton()
            : booking.actionButton() == BookingModel.ACTION_BOOK_AGAIN
                ? confirmAndPayButton()
                : margin(0)
        :
        //Host View
        (booking.isRequested() ||
                    booking.isAccepted() ||
                    booking.isRejected()) &&
                !booking.isExpire
            ? approveRejectButton()
            : createBookingForGuest();
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
    SearchOptions searchOptions = new SearchOptions();
    searchOptions.checkoutDateCalender = booking.calenderCheckout();
    searchOptions.checkinDateCalender = booking.calenderCheckout();
    searchOptions.listingModel = booking.listing;
    var bottomSheetState;
    TextEditingController amountController = TextEditingController();
    TextEditingController calenderController = TextEditingController();
    TextEditingController listingController = TextEditingController();

    amountController.text = booking.totalPayable.toString();
    calenderController.text = searchOptions.getCheckinCheckoutShortDate();
    listingController.text = searchOptions.listingModel!.title;

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
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModelState) {
          bottomSheetState = setModelState;
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      SizedBox(
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
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only numbers ca
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.lineColor)),
                            label: Text("Offer New Price"),
                            labelStyle: TextStyle(color: AppColors.darkGray),
                          )),
                      margin(24),
                      InkWell(
                        onTap: () async {
                          var data = await Get.to(() =>
                              PickCalenderPage(searchOptions: searchOptions));
                          if (data != null) {
                            bottomSheetState(() {
                              searchOptions = data;
                              calenderController.text =
                                  searchOptions.getCheckinCheckoutShortDate();
                            });
                          }
                        },
                        child: TextFieldHelper.clickableTextField(
                            calenderController,
                            "Check In and Check Out Date",
                            "Click here to pick check in and check out date"),
                      ),
                      margin(24),
                      InkWell(
                        onTap: () async {
                          var data = await Get.to(() => MyListingPage());
                          if (data != null) {
                            bottomSheetState(() {
                              searchOptions.listingModel = data;
                              if (searchOptions.listingModel != null) {
                                listingController.text =
                                    searchOptions.listingModel!.title;
                              }
                            });
                          }
                        },
                        child: TextFieldHelper.clickableTextField(
                            listingController,
                            "Listing",
                            "Click here to select listing"),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 50,
                            color: AppColors.darkGray,
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            controller.updateBooking(
                                bookingId: booking.id,
                                status: "ACCEPTED",
                                from: searchOptions.checkinDateCalender == null
                                    ? ""
                                    : Constants.calenderToString(
                                        searchOptions.checkinDateCalender!,
                                        "yyyy-MM-dd"),
                                to: searchOptions.checkoutDateCalender == null
                                    ? ""
                                    : Constants.calenderToString(
                                        searchOptions.checkoutDateCalender!,
                                        "yyyy-MM-dd"),
                                listing_id: searchOptions.listingModel != null
                                    ? searchOptions.listingModel!.id
                                    : "",
                                total_payable: amountController.text);
                          },
                          child: Container(
                            height: 50,
                            color: AppColors.appColor,
                            alignment: Alignment.center,
                            child: Text(
                              "Offer New Price".toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  approveRejectButton() {
    return Column(
      children: [
        ElevatedButton(
            style: buttonStyle(),
            onPressed: () {
              acceptRejectDialog();
            },
            child: buttonText(
                buttonTitle: booking.isRequested()
                    ? "Approve or Reject".toUpperCase()
                    : "Update Status".toUpperCase(),
                height: 50)),
        margin(16),
        spatialOfferButton()
      ],
    );
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
                        Component.dismissDialog();

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
                        Component.dismissDialog();
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

  createBookingForGuest() {
    return ElevatedButton(
        style: buttonStyle(backgroundColor: Colors.green),
        onPressed: () {
          createNewBookingBottomSheet();
        },
        child: buttonText(
            buttonTitle: "Create New Booking".toUpperCase(), height: 50));
  }

  void createNewBookingBottomSheet() {
    SearchOptions searchOptions = new SearchOptions();
    var bottomSheetState;
    TextEditingController guestController = TextEditingController();
    TextEditingController calenderController = TextEditingController();
    TextEditingController listingController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: Component.bottomSheetShape(),
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModelState) {
          bottomSheetState = setModelState;
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
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
                        'Create New Booking',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textColorBlack),
                      ),
                      margin(24),
                      InkWell(
                        onTap: () async {
                          var data = await Get.to(() =>
                              PickCalenderPage(searchOptions: searchOptions));
                          if (data != null) {
                            bottomSheetState(() {
                              searchOptions = data;
                              calenderController.text =
                                  searchOptions.getCheckinCheckoutShortDate();
                            });
                          }
                        },
                        child: TextFieldHelper.clickableTextField(
                            calenderController,
                            "Check In and Check Out Date",
                            "Click here to pick check in and check out date"),
                      ),
                      margin(24),
                      InkWell(
                        onTap: () async {
                          final data = await showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.white,
                            shape: Component.bottomSheetShape(),
                            builder: (context) => GuestCountBottomSheet(
                                searchOptions: searchOptions),
                          );

                          if (data != null) {
                            bottomSheetState(() {
                              searchOptions = data;
                              guestController.text =
                                  searchOptions.getGuestCounts();
                            });
                          }
                        },
                        child: TextFieldHelper.clickableTextField(
                            guestController,
                            "Total Guest",
                            "Click here to select total guest"),
                      ),
                      margin(24),
                      InkWell(
                        onTap: () async {
                          var data = await Get.to(() => MyListingPage());
                          if (data != null) {
                            bottomSheetState(() {
                              searchOptions.listingModel = data;
                              if (searchOptions.listingModel != null) {
                                listingController.text =
                                    searchOptions.listingModel!.title;
                              }
                            });
                          }
                        },
                        child: TextField(
                            enabled: false,
                            controller: listingController,
                            decoration: const InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.lineColor)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              label: Text("Listing"),
                              hintText: "Click here to select listing",
                              labelStyle: TextStyle(color: AppColors.darkGray),
                            )),
                      ),

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
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 50,
                            color: AppColors.darkGray,
                            alignment: Alignment.center,
                            child: Text(
                              "Cancel".toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            controller.createNewBookingForGuest(searchOptions);
                          },
                          child: Container(
                            height: 50,
                            color: AppColors.appColor,
                            alignment: Alignment.center,
                            child: Text(
                              "Create New booking".toUpperCase(),
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
}
