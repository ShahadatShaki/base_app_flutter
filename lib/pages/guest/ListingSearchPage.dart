import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../component/ImageSlider.dart';
import '../../controller/ListingSearchController.dart';
import '../../model/ListingModel.dart';
import '../../model/SearchOptions.dart';
import '../../utility/AppColors.dart';
import '../ListingDetailsPage.dart';

class ListingSearchPage extends StatelessWidget {
  final ListingSearchController controller = Get.put(ListingSearchController());
  SearchOptions searchOptions;
  late BuildContext context;

  ListingSearchPage({required this.searchOptions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.searchOptions = searchOptions;
    controller.getData();
    this.context = context;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: getMainLayout(),
    );
  }

  getMainLayout() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          searchOptionsLayout(),
          Obx(() => showListOrEmptyView()) // merchantCardDesign()
        ],
      ),
    );
  }

  showListOrEmptyView() {
    return Expanded(
      child: Container(
          child: !controller.apiCalled.value
              ? Component.loadingView()
              : (controller.apiCalled.value && controller.dataList.isNotEmpty)
                  ? uiDesign()
                  : Component.emptyView("No Data Found",
                      "assets/animation/empty_item.json")),
    );

    return Expanded(
      child: Column(
        children: [
          Visibility(
              visible: !controller.apiCalled.value,
              // visible: false,
              child: Component.loadingView()),
          Visibility(
            visible: controller.apiCalled.value &&
                controller.dataList.value.isNotEmpty,
            // visible: false,
            child: Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.dataList.value.length,
                // shrinkWrap: true,
                itemBuilder: (BuildContext c, int index) {
                  return cardDesign(index, controller.dataList.value[index]);
                },
              ),
            ),
          ),
          Visibility(
              visible: controller.dataList.value.isEmpty &&
                  controller.apiCalled.value,
              child: Component.emptyView(
                  "No Data Found", "assets/animation/empty_item.json")),
        ],
      ),
    );
  }

  uiDesign() {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.dataList.value.length,
      // shrinkWrap: true,
      itemBuilder: (BuildContext c, int index) {
        return cardDesign(index, controller.dataList.value[index]);
      },
    );
  }

  searchOptionsLayout() {
    return Container(
        margin: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 24),
        decoration: Component.containerRoundShape(),
        padding:
            const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    searchOptions.getName(),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  SizedBox(
                      height: searchOptions.guestCount != 0 ||
                              searchOptions
                                  .getCheckinCheckoutShortDate()
                                  .isNotEmpty
                          ? 6
                          : 0),
                  searchOptions.guestCount == 0 &&
                          searchOptions.getCheckinCheckoutShortDate().isEmpty
                      ? SizedBox()
                      : Row(
                          children: [
                            Text(
                              searchOptions.getCheckinCheckoutShortDate(),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textColorBlack),
                            ), //Date Text
                            SizedBox(
                                width: searchOptions
                                        .getCheckinCheckoutShortDate()
                                        .isNotEmpty
                                    ? 16
                                    : 0),
                            searchOptions.guestCount != 0
                                ? Component.showIcon(
                                    name: AssetsName.guest_fill,
                                    size: 16,
                                  )
                                : const SizedBox(),
                            SizedBox(width: 8),
                            searchOptions.guestCount != 0
                                ? Text(
                                    "${searchOptions.guestCount}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textColorBlack),
                                  )
                                : SizedBox(), //Guest Count Text
                          ],
                        )
                ],
              ),
            ),
            Component.showIcon(name: AssetsName.edit, size: 24)
          ],
        ));
  }

  cardDesign(int index, ListingModel item) {
    return InkWell(
      onTap: () {
        Get.to(() => ListingDetailsPage(listingId: item.id!.toString()));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageSlider(index, item),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    item.title!,
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Component.showIcon(name: AssetsName.star, size: 16),
                const SizedBox(width: 4),
                Text(
                  "${item.reviewsAvg} (${item.reviewsCount})",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.address!,
              style: const TextStyle(
                color: AppColors.darkGray,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            (item.getPrice()! > int.parse(item.averagePrice)) && item.averagePrice != "0"
                ? Container(
                    margin: EdgeInsets.only(bottom: 8),
                    child: Text(
                      "BDT ${item.getPrice()} ",
                      style: const TextStyle(
                        color: AppColors.darkGray,
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  )
                : SizedBox(),
            Container(
              margin: EdgeInsets.only(bottom: 12),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'BDT ${item.getCurrentPrice()}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textColorBlack)),
                    const TextSpan(
                        text: ' /day',
                        style:
                            TextStyle(fontSize: 16, color: AppColors.darkGray)),
                  ],
                ),
              ),
            ),
            controller.searchOptions.dayDiff() != 0
                ? RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                'BDT ${item.getCurrentPrice() * controller.searchOptions.dayDiff()}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColorBlack)),
                        const TextSpan(
                            text: ' /day',
                            style: TextStyle(
                                fontSize: 16, color: AppColors.darkGray)),
                      ],
                    ),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  imageSlider(int index, ListingModel item) {
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
                controller.dataList[index] = item;
              },
              enableInfiniteScroll: true),
        ),
        ImageSlider.indicator(item),
      ],
    );
  }
}
