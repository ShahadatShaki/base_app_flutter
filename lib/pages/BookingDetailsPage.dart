import 'dart:async';

import 'package:base_app_flutter/controller/ListingDetailsController.dart';
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
import 'guest/BookingRequestPage.dart';

class BookingDetailsPage extends StatelessWidget {
  final ListingController controller = Get.put(ListingController());
  String listingId;
  late BuildContext context;

  BookingDetailsPage({required this.listingId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.listingId = listingId;
    controller.getData();
    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: Component.appbar(name: "Details"),
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
                    controller.listing.value.title != null)
                ? uiDesign(controller.listing.value)
                : Component.emptyView("Something Went Wrong",
                    "assets/animation/error_animation.json"));
  }

  uiDesign(ListingModel value) {
    return Container(
      child: Text("Booking Details"),
    );
  }


}
