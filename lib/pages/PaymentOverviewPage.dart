import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/controller/BookingDetailsController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/utility/AppStrings.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
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
    controller.getPaymentUrl(false);
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

    return Container(
      color: AppColors.backgroundColor,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  margin(16),
                  Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Text(
                          "Oder ID: #${booking.id}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        margin(16),
                        showIcon(name: AssetsName.guest)
                      ],
                    ),
                  ),
                  margin(24),
                  Container(
                    padding: EdgeInsets.all(24),
                    color: AppColors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Select Payment Method",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        margin(24),
                        Container(
                          decoration: containerRoundShapeWithBorder(
                              borderWidth: 1, borderColor: AppColors.lineColor),
                          child: RadioListTile(
                            title: Row(
                              children: [
                                const Text(
                                  "Bkash",
                                  style: TextStyle(fontSize: 14),
                                ),
                                const Spacer(
                                  flex: 1,
                                ),
                                loadImage(
                                    imageUrl: AssetsName.generic_placeholder,
                                    width: 80,
                                    height: 30)
                              ],
                            ),
                            value: "bkash",
                            // groupValue: controller.paymentGateway.value.toString(),
                            groupValue: controller.paymentGateway.value,
                            onChanged: (value) {
                              controller.paymentGateway.value = value.toString();
                            },
                          ),
                        ),
                        margin(24),
                        Container(
                          decoration: containerRoundShapeWithBorder(
                              borderWidth: 1, borderColor: AppColors.lineColor),
                          child: RadioListTile(
                            title: Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Other Payment Methods",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                                margin(16),
                                loadImage(
                                    imageUrl: AssetsName.generic_placeholder,
                                    width: 80,
                                    height: 30)
                              ],
                            ),
                            value: "ssl",
                            // groupValue: controller.paymentGateway.value.toString(),
                            groupValue: controller.paymentGateway.value,
                            onChanged: (value) {
                              controller.paymentGateway.value = value.toString();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.white,
            padding: EdgeInsets.all(16),
            child: confirmAndPayButton(),
          ),

        ],
      ),
    );
  }

  confirmAndPayButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            margin(8),
            Expanded(
              flex: 1,
              child: Text(
                "Total BDT ${controller.paymentAmount.value}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
            ElevatedButton(
              style: buttonStyle(),
              onPressed: () {
                controller.getPaymentUrl(true);
              },
              child: buttonText(
                width: 100,
                buttonTitle: "Make Payment",
                height: 50,
              ),
            ),
          ],
        )
      ],
    );
  }
}
