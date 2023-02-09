import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/SearchOptions.dart';
import '../utility/AppColors.dart';
import '../utility/AssetsName.dart';
import 'Component.dart';

class GuestBottomSheet {
  static showGuestCountBottomSheet(
      BuildContext context, var searchOptionsRx) {
    var bottomSheet;
    SearchOptions searchOptions = searchOptionsRx.value;
    SearchOptions damiSearchOption = SearchOptions();
    damiSearchOption.guestCount = searchOptions.guestCount;
    damiSearchOption.childCount = searchOptions.childCount;
    damiSearchOption.infantCount = searchOptions.infantCount;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context,
            StateSetter setModelState /*You can rename this!*/) {
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
                          style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                showCounterInput(bottomSheet,damiSearchOption, "Adults", "Ages 13 or above"),
                Container(
                  margin: EdgeInsets.only(top: 24, bottom: 24),
                  height: 1,
                  color: AppColors.lightestLineColor,
                ),
                showCounterInput(bottomSheet,damiSearchOption,"Child", "Ages 2-12"),
                Container(
                  margin: EdgeInsets.only(top: 24, bottom: 24),
                  height: 1,
                  color: AppColors.lightestLineColor,
                ),
                showCounterInput(bottomSheet,damiSearchOption,"Infants", "Under 2"),
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(8))),
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
                          searchOptions.guestCount =
                              damiSearchOption.guestCount;
                          searchOptions.childCount =
                              damiSearchOption.childCount;
                          searchOptions.infantCount =
                              damiSearchOption.infantCount;
                          // });

                          searchOptionsRx.value = searchOptions;
                          searchOptionsRx.refresh();
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
      },
    );
  }

  static showCounterInput(var bottomSheet, SearchOptions damiSearchOption, String title, String subtitle) {
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