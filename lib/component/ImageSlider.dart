import 'package:base_app_flutter/component/Component.dart';
import 'package:flutter/material.dart';

import '../model/ListingModel.dart';

class ImageSlider {
  static getImageSlider(ListingModel item) {
    List<Widget> imageSliders = item.images
        .map(
          (item) => Component.loadImage(imageUrl: item.url, height: 240, cornerRadius: 8),
        )
        .toList();

    return imageSliders;
  }

  static indicator(ListingModel item) {
    indicatorPositionScroll(item);
    Widget widget = Container(
      alignment: Alignment.center,
      height: 8,
      margin: EdgeInsets.only(bottom: 12),
      width: 144,
      child: ListView.builder(
        itemCount: item.images.length,
        scrollDirection: Axis.horizontal,
        controller: item.itemScrollController,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Colors.white)
                    .withOpacity(
                        item.sliderCurrentPosition == index ? 1 : 0.6)),
          );
        },
      ),
    );

    return widget;
  }

  static Future<void> indicatorPositionScroll(ListingModel item) async {
    if (item.itemScrollController.hasClients) {
      if (item.sliderCurrentPosition == 0) {
        item.itemScrollController.animateTo(0,
            duration: Duration(milliseconds: 1000), curve: Curves.ease);
      } else if (item.sliderCurrentPosition > 4) {
        double currentScroll = item.itemScrollController.position.pixels;
        currentScroll = (item.sliderCurrentPosition - 4) * 16;
        item.itemScrollController.animateTo(currentScroll,
            duration: Duration(milliseconds: 1000), curve: Curves.ease);
      }
    }
  }
}
