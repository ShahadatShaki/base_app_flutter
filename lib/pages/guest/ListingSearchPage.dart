import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../component/Component.dart';
import '../../controller/ListingSearchController.dart';
import '../../model/ListingModel.dart';
import '../../model/SearchOptions.dart';
import '../../utility/AppColors.dart';

class ListingSearchPage extends StatelessWidget {
  final ListingSearchController controller = Get.put(ListingSearchController());
  SearchOptions searchOptions;

  ListingSearchPage({required this.searchOptions, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.searchOptions = searchOptions;
    controller.getData();
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
                  return cardDesign(controller.dataList.value[index]);
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
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textColorBlack,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        searchOptions.getCheckinCheckoutShortDate(),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textColorBlack),
                      ), //Date Text
                      SizedBox(width: 16),
                      Component.showIcon(
                        name: AssetsName.guest_fill,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${searchOptions.guestCount}",
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textColorBlack),
                      ), //Guest Count Text
                    ],
                  )
                ],
              ),
            ),
            Component.showIcon(name: AssetsName.edit, size: 24)
          ],
        ));
  }

  cardDesign(ListingModel item) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: getImageSlider(item),
            options: CarouselOptions(
                viewportFraction: 1,
                enlargeCenterPage: false,
                enableInfiniteScroll: true),
          ),
          SizedBox(height: 16),
          Text(
            item.title!,
            style: TextStyle(
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  getImageSlider(ListingModel item) {
    List<Widget> imageSliders = item.images!
        .map(
          (item) => ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: InkWell(
              onTap: () => {Constants.showToast("Slider clicked")},
              child: Component.loadImage(imageUrl: item.url!),
            ),
          ),
        )
        .toList();

    return imageSliders;
  }
}
