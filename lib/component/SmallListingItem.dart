import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class SmallListingItem extends BaseStatelessWidget {
  final ListingModel listingModel;

  SmallListingItem({required this.listingModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        loadImage(imageUrl: listingModel.images[0].url, width: 80, height: 60, cornerRadius: 4),
        margin(16),
        Expanded(
            child: Text(
          listingModel.title,
          maxLines: 3,
          style: Component.textStyle16bkw500(),
        ))
      ],
    );
  }
}
