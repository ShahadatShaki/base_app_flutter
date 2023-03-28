import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/controller/BookingDetailsController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/utility/AppStrings.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../utility/AppColors.dart';

class PaymentOverviewPage extends BaseStatelessWidget {
  final BookingDetailsController controller =
      Get.put(BookingDetailsController());
  String id;
  late BuildContext context;
  late BookingModel booking;

  PaymentOverviewPage({required this.id, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getPaymentUrl("10", false);
    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Payment Overview"),
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return SafeArea(
      child: Obx(() => uiDesign(controller.booking.value)),
    );
  }

  // showListOrEmptyView() {
  //   return Container(
  //       child: !controller.apiCalled.value
  //           ? Component.loadingView()
  //           : (controller.apiCalled.value &&
  //                   controller.booking.value.id.isNotEmpty)
  //               ? uiDesign(controller.booking.value)
  //               : Component.emptyView("Something Went Wrong",
  //                   "assets/animation/error_animation.json"));
  // }

  uiDesign(BookingModel value) {
    booking = value;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          margin(16),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  "Oder ID: #${booking.id}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                ),

              ],
            ),
          ),
          Text("data ${booking.amount}"),
          confirmAndPayButton()
        ],
      ),
    );
  }

  confirmAndPayButton() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: controller.isTermsChecked.value,
              onChanged: (value) {
                controller.isTermsChecked.value = value ?? false;
              },
            ),
            Expanded(
                child: Html(
              data: AppStrings.termsAndCondition,

              // style: {
              //   "p": Style(
              //     border: Border(bottom: BorderSide(color: Colors.grey)),
              //     padding: const EdgeInsets.all(16),
              //     fontSize: FontSize(30),
              //   ),
              // },
              onLinkTap: (url, context, attributes, element) {
                Constants.showToast(url ?? "");
              },
            )),
          ],
        ),
        margin(16),
        ElevatedButton(
            style: buttonStyle(),
            onPressed: () {},
            child: buttonText(buttonTitle: "Confirm And Pay", height: 50))
      ],
    );
  }
}
