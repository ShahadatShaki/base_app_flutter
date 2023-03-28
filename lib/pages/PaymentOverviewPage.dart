import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/ListingComponent.dart';
import 'package:base_app_flutter/controller/BookingDetailsController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/pages/ListingDetailsPage.dart';
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

class PaymentOverviewPage extends StatelessWidget with Component {
  final BookingDetailsController controller = Get.put(BookingDetailsController());
  String id;
  late BuildContext context;
  late BookingModel item;

  PaymentOverviewPage({required this.id, Key? key}) : super(key: key);

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
            confirmAndPayButton()
          ],
        ),
      ),
    );
  }


  confirmAndPayButton() {
    return
    Column(
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
