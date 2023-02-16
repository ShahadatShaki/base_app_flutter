import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utility/AssetsName.dart';
import 'Component.dart';

class ListingComponent {
  static ratingView(ListingModel listingModel) {
    return Row(
      children: [
        Component.showIcon(name: AssetsName.star, size: 16),
        const SizedBox(width: 4),
        Text(
          "${listingModel.reviewsAvg} (${listingModel.reviewsCount})",
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        )
      ],
    );
  }

  static titleAndDetails(
      {required String title,
      required String details,
      String iconFront = "",
      String iconBack = "",
      Color? iconBackColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: AppColors.darkGray)),
        const SizedBox(height: 8),
        Row(
          children: [
            iconFront.isNotEmpty
                ? Component.showIcon(name: iconFront, size: 14)
                : const SizedBox(),
            SizedBox(width: iconFront.isNotEmpty ? 8 : 0),
            Expanded(
              child: Text(details,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textColorBlack)),
            ),
            SizedBox(width: iconBack.isNotEmpty ? 8 : 0),
            iconBack.isNotEmpty
                ? Component.showIcon(
                    name: iconBack, size: 14, color: iconBackColor)
                : const SizedBox(),
          ],
        ),
      ],
    );
  }
}
