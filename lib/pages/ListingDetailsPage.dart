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

class ListingDetailsPage extends StatelessWidget {
  final ListingController controller = Get.put(ListingController());
  String listingId;
  late BuildContext context;

  ListingDetailsPage({required this.listingId, Key? key}) : super(key: key);

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

  uiDesign(ListingModel item) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  imageSlider(item),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                        flex: 4,
                        child: Component.loadImage(
                            imageUrl: item.images!.length > 1
                                ? item.images![1].url!
                                : "",
                            cornerRadius: 8,
                            height: 100)),
                    const SizedBox(width: 8),
                    Expanded(
                        flex: 5,
                        child: Component.loadImage(
                            imageUrl: item.images!.length > 2
                                ? item.images![2].url!
                                : "",
                            cornerRadius: 8,
                            height: 100))
                  ]),
                  const SizedBox(height: 24),
                  Text(
                    item.title!,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textColorBlack),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      showKeyInfo(
                          AssetsName.max_guest, "Max Guest", item.maxGuest!),
                      Container(
                          width: 1, height: 35, color: AppColors.lineColor),
                      showKeyInfo(AssetsName.bedroom, "Bedroom", item.bedroom!),
                      Container(
                          width: 1, height: 35, color: AppColors.lineColor),
                      showKeyInfo(AssetsName.bed, "Bed", item.beds!),
                      Container(
                          width: 1, height: 35, color: AppColors.lineColor),
                      showKeyInfo(AssetsName.bathroom, "Bath", item.bathroom!),
                    ],
                  ),
                  const SizedBox(height: 18),
                  checkInCheckOutUi(item),
                  const SizedBox(height: 32),
                  const Text(
                    'Listed by property owner',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGray),
                  ),
                  const SizedBox(height: 16),
                  hostDetails(item),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Component.showIcon(
                          name: AssetsName.star,
                          color: AppColors.warning,
                          size: 20),
                      const SizedBox(width: 10),
                      Text("${item.reviewsAvg} (${item.reviewsCount} Reviews)",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textColorBlack)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  hostSpecilities(
                      AssetsName.language, "Languages:", "Bangla, English"),
                  const SizedBox(height: 12),
                  hostSpecilities(
                      AssetsName.response_rate, "Response rate:", "100%"),
                  const SizedBox(height: 12),
                  hostSpecilities(
                      AssetsName.clock, "Response time:", "within an hour"),
                  const SizedBox(height: 18),
                  contactHostButton(),
                  const SizedBox(height: 24),
                  titleAndDescription(
                      "Property Description", item.description!),
                  const SizedBox(height: 32),
                  titleAndDescription("Property Rules", item.description!),
                  const SizedBox(height: 32),
                  sectionTitle("Map"),
                  showMap(item),
                  reviews(item),
                  cancellationPolicy(item)
                  // Container(height: 1, width:double.infinity, color: AppColors.lineColor,margin: EdgeInsets.only(top: 8, bottom: 16),),
                  //
                ],
              ),
            ),
          ),
        ),
        bottomView(item)
      ],
    );
  }

  imageSlider(ListingModel item) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          items: ImageSlider.getImageSlider(item),
          options: CarouselOptions(
              viewportFraction: 1,
              enlargeCenterPage: false,
              onPageChanged: (i, reason) {
                item.sliderCurrentPosition = i;
                controller.listing.value = item;
                controller.listing.refresh();
              },
              enableInfiniteScroll: true),
        ),
        ImageSlider.indicator(item),
      ],
    );
  }

  showKeyInfo(String icon, String s, dynamic count) {
    return Column(
      children: [
        Text(
          s,
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.darkGray),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Component.showIcon(name: icon, size: 20),
            const SizedBox(width: 8),
            Text(
              count.toString(),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textColorBlack),
            ),
          ],
        )
      ],
    );
  }

  checkInCheckOutUi(ListingModel item) {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Check In",
                  style: TextStyle(fontSize: 12, color: AppColors.darkGray)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Component.showIcon(name: AssetsName.clock, size: 14),
                  const SizedBox(width: 8),
                  Text(item.checkIn!,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColorBlack)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Check Out",
                  style: TextStyle(fontSize: 12, color: AppColors.darkGray)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Component.showIcon(name: AssetsName.clock, size: 14),
                  const SizedBox(width: 8),
                  Text(item.checkOut!,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textColorBlack)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  hostDetails(ListingModel item) {
    return Row(
      children: [
        Component.loadCircleImage(
            imageUrl: item.host!.image!.url!, width: 50, height: 50),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hello, I am ${item.host!.firstName!}",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textColorBlack)),
            const SizedBox(height: 8),
            Row(
              children: [
                Component.showIcon(name: AssetsName.verify, size: 14),
                const SizedBox(width: 4),
                const Text("Identity verified",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGray)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  hostSpecilities(String icon, String font, String back) {
    return Row(
      children: [
        Component.showIcon(name: icon, size: 20),
        const SizedBox(width: 10),
        Text(font,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.darkGray)),
        const SizedBox(width: 8),
        Text(back,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textColorBlack)),
      ],
    );
  }

  contactHostButton() {
    return TextButton(
      style: Component.textButtonStyle(radius: 4),
      onPressed: () {
        // Get.to(()=> ListingSearchPage(searchOptions: searchOptions));
      },
      child: Component.textButtonText(buttonTitle: "Contact Host"),
    );
  }

  titleAndDescription(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(title),
        const SizedBox(height: 16),
        Text(description,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textColorBlack)),
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

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  showMap(ListingModel item) {
    return Container(
      height: 250,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  reviews(ListingModel item) {
    return InkWell(
      // onTap: ,
      child: Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          children: [
            sectionTitle("Reviews"),
            const SizedBox(width: 4),
            Expanded(
              child: Text("${item.reviewsAvg} (${item.reviewsCount} Reviews)",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkGray)),
            ),
            Text("View Reviews",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.appColor)),
          ],
        ),
      ),
    );
  }

  cancellationPolicy(ListingModel item) {
    return InkWell(
      // onTap: ,
      child: Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        child: Row(
          children: [
            sectionTitle("Cancellation Policy"),
          ],
        ),
      ),
    );
  }

  bottomView(ListingModel item) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                          text: 'BDT ${item.getCurrentPrice()}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColorBlack)),
                      const TextSpan(
                          text: ' /day',
                          style: TextStyle(
                              fontSize: 14, color: AppColors.darkGray)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bookNowButton(item)
        ],
      ),
    );
  }

  bookNowButton(ListingModel item) {
    return TextButton(
      style: Component.textButtonStyle(radius: 4),
      onPressed: () {
        Get.to(() =>
            BookingRequestPage(listingId: item.id!.toString(), listing: item));
      },
      child: Container(
          height: 40,
          margin: EdgeInsets.only(left: 50, right: 50),
          alignment: Alignment.center,
          child: Text(
            "Book  Now",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          )),
    );
  }
}
