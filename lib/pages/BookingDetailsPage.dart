import 'dart:async';

import 'package:base_app_flutter/controller/ListingDetailsController.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../component/Component.dart';
import '../../model/ListingModel.dart';
import '../../utility/AppColors.dart';
import '../component/ImageSlider.dart';
import '../controller/BookingController.dart';
import 'guest/BookingRequestPage.dart';

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
                    controller.booking.value.id != null)
                ? uiDesign(controller.booking.value)
                : Component.emptyView("Something Went Wrong",
                    "assets/animation/error_animation.json"));
  }

  uiDesign(BookingModel value) {
    item =  value;

    return Container(
      child: Container(
        margin: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          ],
        ),
      ),
    );
  }


}
