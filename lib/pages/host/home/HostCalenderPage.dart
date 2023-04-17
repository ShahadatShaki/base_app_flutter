import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/component/SmallListingItem.dart';
import 'package:base_app_flutter/controller/HostCalenderController.dart';
import 'package:base_app_flutter/pages/host/MyListingPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HostCalenderPage extends BaseStatelessWidget {
  final HostCalenderController controller = Get.put(HostCalenderController());

  HostCalenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getMyListing();
    // controller.getBlockDateList();
    return Scaffold(
        body: SafeArea(
            child: Obx(
      () => Container(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 24),
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          color: AppColors.white,
          child: Column(
            children: [
              bookingDetails(),
              Expanded(
                  // flex: 1,
                  child: controller.calenderData.value
                      ? showCalender()
                      : Component.loadingView()),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                style: Component.textButtonStyle(),
                onPressed: () {},
                child: Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: const Text('Done')),
              ),
            ],
          )),
    )));
  }

  bookingDetails() {
    var listing = controller.listing.value;
    return listing.id.isEmpty
        ? margin(0)
        : InkWell(
            onTap: () async {
              var data = await Get.to(() => MyListingPage());
              if (data != null) {
                controller.listing.value = data;
                controller.listing.refresh();
                controller.getBlockDateList();
              }
            },
            child: Card(
              margin: EdgeInsets.all(8),
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: SmallListingItem(
                      listingModel: controller.listing.value,
                    )),
                    margin(8),
                    showIcon(name: AssetsName.arrow_drop_down)
                  ],
                ),
              ),
            ),
          );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // inspect(dateRangePickerSelectionChangedArgs);
    // damiSearchOptions.checkinDateCalender = args.value.startDate;
    // damiSearchOptions.checkoutDateCalender = args.value.endDate;
    controller.selectedDates.value = args.value;
    controller.selectedDates.refresh();
  }

  dateInBlockDate(DateTime date) {
    for (int i = 0; i < controller.blockDatesList.length; i++) {
      var item = controller.blockDatesList[i];
      if (Constants.totalDays(date) == Constants.totalDays(item)) {
        if (controller.blockDatesObjList[i].price.isNotEmpty) {
          return AppColors.lightestGreen;
        }
        return AppColors.lightestRed;
      }
    }

    return AppColors.white;
  }

  dateInSelectedDate(DateTime date) {
    for (int i = 0; i < controller.selectedDates.length; i++) {
      if (Constants.totalDays(date) ==
          Constants.totalDays(controller.selectedDates[i])) {
        return true;
      }
    }

    return false;
  }

  showCalender() {
    return SfDateRangePicker(
      navigationMode: DateRangePickerNavigationMode.scroll,
      navigationDirection: DateRangePickerNavigationDirection.vertical,
      enableMultiView: true,
      selectionColor: AppColors.transparent,
      selectionMode: DateRangePickerSelectionMode.multiple,
      onSelectionChanged: _onSelectionChanged,
      cellBuilder: (context, cellDetails) {
        var bgcolor = dateInBlockDate(cellDetails.date);
        var isSelected = dateInSelectedDate(cellDetails.date);

        return Container(
          alignment: Alignment.center,
          decoration: isSelected
              ? BoxDecoration(shape: BoxShape.circle, color: AppColors.appColor)
              : BoxDecoration(shape: BoxShape.rectangle, color: bgcolor),
          child: Text(
            cellDetails.date.day.toString(),
            style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.white : AppColors.black),
          ),
        );
      },
    );
  }
}
