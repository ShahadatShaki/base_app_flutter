import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/controller/RatingController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';

class WriteReviewHostPage extends BaseStatelessWidget {
  final RatingController controller = Get.put(RatingController());
  BookingModel bookingModel;
  late BuildContext context;

  WriteReviewHostPage({required this.bookingModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getSingleBooking(bookingModel.id);
    this.context = context;
    controller.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Write Review"),
      body: Obx(() => getMainLayout()),
    );
  }

  getMainLayout() {
    bookingModel = controller.booking.value;
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Container(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                      ),
                      loadCircleImage(
                          imageUrl: bookingModel.id.isNotEmpty?bookingModel.images[0].url:"",
                          width: 70,
                          height: 70),
                      margin(8),
                      Text(bookingModel.host.firstName,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black)),
                      ratingView("Rate Guests Behaviour",
                          controller.rateGuestsBehaviour),
                      ratingView("Observance of House Rules",
                          controller.rateHouseRules),
                      ratingView("Rate Guests Communication",
                          controller.rateGuestsCommunication),
                      margin(24),
                      const Text(
                          "Write a fair, honest review so future host know what to expect",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black)),
                      margin(20),
                      TextField(
                          controller: controller.reviewBodyController,
                          minLines: 5,
                          textAlign: TextAlign.start,
                          maxLines: 6,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.lineColor)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: Text("Write your experience"),
                            hintText: "Write your experience",
                            alignLabelWithHint: false,
                            // hintStyle: TextStyle(al),
                            labelStyle: TextStyle(color: AppColors.darkGray),
                          ))
                    ],
                  )),
            ),
          ),
          TextButton(
            style: Component.textButtonStyle(radius: 0),
            onPressed: () {
              controller.submitReview();
            },
            child: buttonText(buttonTitle: "Submit "),
          )
        ],
      ),
    );
  }

  bookNowButton() {
    return TextButton(
      style: Component.textButtonStyle(radius: 8),
      onPressed: () {
        // controller.bookingRequest();
      },
      child: buttonText(buttonTitle: "Request for book"),
    );
  }

  ratingView(
    String title,
    RxInt rate,
  ) {
    return Column(
      children: [
        margin(24),
        Text(title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.black)),
        margin(8),
        RatingBar.builder(
          // initialRating: rate.value.toDouble(),
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          // tapOnlyMode: true,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            rate.value = rating as int;
          },

        ),
      ],
    );
  }

// showProgressDialog() {
//   if (controller.showProgressBar.value) {
//     Component.dialog(context);
//   }
// }
}
