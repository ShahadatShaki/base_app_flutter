import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class GuestCountBottomSheet extends BaseStatelessWidget {
  var bottomSheet;
  SearchOptions searchOptions;
  late SearchOptions damiSearchOption;
  var adultCount = 0;
  var infantCount = 0;
  var childCount = 0;

  GuestCountBottomSheet({Key? key, required this.searchOptions}) {
    damiSearchOption = searchOptions.clone();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModelState) {
      bottomSheet = setModelState;

      return Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                const Expanded(
                    child: Text(
                  'Select Guest Size',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.darkGray,
                          fontWeight: FontWeight.w500),
                    )),
              ],
            ),
            const SizedBox(height: 24),
            showCounterInput(damiSearchOption, "Adults", "Ages 13 or above"),
            Container(
              margin: EdgeInsets.only(top: 24, bottom: 24),
              height: 1,
              color: AppColors.lightestLineColor,
            ),
            showCounterInput(damiSearchOption, "Child", "Ages 2-12"),
            Container(
              margin: EdgeInsets.only(top: 24, bottom: 24),
              height: 1,
              color: AppColors.lightestLineColor,
            ),
            showCounterInput(damiSearchOption, "Infants", "Under 2"),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.lineColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      foregroundColor: AppColors.darkGray,
                      backgroundColor: AppColors.white,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: const Text('Cancel')),
                  ),
                ),
                SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: Component.textButtonStyle(),
                    onPressed: () {
                      // setState(() {
                      searchOptions.guestCount = damiSearchOption.guestCount;
                      searchOptions.childCount = damiSearchOption.childCount;
                      searchOptions.infantCount = damiSearchOption.infantCount;
                      // });

                      Get.back(result: damiSearchOption);
                    },
                    child: Container(
                        height: 40,
                        alignment: Alignment.center,
                        child: const Text('Done')),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  showCounterInput(
      SearchOptions damiSearchOption, String title, String subtitle) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, color: AppColors.textColorBlack)),
                SizedBox(height: 8),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.darkGray)),
              ],
            ),
          ),
          InkWell(
              onTap: () {
                bottomSheet(() {
                  damiSearchOption.changeCount(title, -1);
                });
              },
              child: Component.showIcon(
                name: AssetsName.minus,
                size: 40,
              )),
          Container(
            margin: EdgeInsets.only(right: 12, left: 12),
            child: Text("${damiSearchOption.getCount(title)} ",
                style: const TextStyle(
                    fontSize: 16, color: AppColors.textColorBlack)),
          ),
          InkWell(
              onTap: () {
                bottomSheet(() {
                  damiSearchOption.changeCount(title, 1);
                });
              },
              child: Component.showIcon(name: AssetsName.plus, size: 40))
        ],
      ),
    );
  }
}
