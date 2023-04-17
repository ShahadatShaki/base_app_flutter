import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/component/SmallListingItem.dart';
import 'package:base_app_flutter/controller/HostCalenderController.dart';
import 'package:base_app_flutter/pages/host/MyListingPage.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/AssetsName.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  child: Stack(
                children: [
                  controller.calenderData.value
                      ? showCalender()
                      : Component.loadingView(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: controller.selectedDates.length > 0
                        ? showUpdateOptions()
                        : margin(0),
                  )
                ],
              )),
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

  getInitialPriceForUpdate(DateTime date) {
    for (int i = 0; i < controller.blockDatesList.length; i++) {
      var item = controller.blockDatesList[i];
      if (Constants.totalDays(date) == Constants.totalDays(item)) {
        if (controller.blockDatesObjList[i].price.isNotEmpty) {
          return controller.blockDatesObjList[i].price;
        }
        return controller.listing.value.price;
      }
    }

    return controller.listing.value.price;
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
      monthViewSettings: DateRangePickerMonthViewSettings(),
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

  showUpdateOptions() {
    var price = getInitialPriceForUpdate(controller.selectedDates.first);
    controller.amountController.text = price;
    return Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.all(8),
        child: ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text("Calender Action",
                                style: Component.textStyle16bkw500()),
                          ),
                          Align(
                              alignment: Alignment.topRight,
                              child: showIcon(name: AssetsName.call))
                        ],
                      ),
                      margin(16),
                      TextField(
                          controller: controller.amountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.lineColor)),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            label: Text("Custom Price"),
                            hintText: "Custom Price",
                            labelStyle: TextStyle(color: AppColors.darkGray),
                          )),
                      margin(16),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.calenderOptionOnAvailable.value =
                                    !controller.calenderOptionOnAvailable.value;
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 18, right: 18, top: 8, bottom: 8),
                                decoration:
                                    controller.calenderOptionOnAvailable.value
                                        ? containerRoundShapeWithBorder(
                                            borderWidth: 1,
                                            borderColor: AppColors.appColor,
                                            size: 25)
                                        : null,
                                child: Text("Availabile"),
                              ),
                            ),
                          ),
                          margin(24),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.calenderOptionOnAvailable.value =
                                    !controller.calenderOptionOnAvailable.value;
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: EdgeInsets.only(
                                    left: 18, right: 18, top: 8, bottom: 8),
                                decoration:
                                    controller.calenderOptionOnAvailable.value
                                        ? null
                                        : containerRoundShapeWithBorder(
                                            borderWidth: 1,
                                            borderColor: AppColors.appColor,
                                            size: 25),
                                child: Text("Block"),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.updateCalenderSettings();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    alignment: Alignment.center,
                    color: AppColors.appColor,
                    child: const Text(
                      "UPDATE",
                      style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
