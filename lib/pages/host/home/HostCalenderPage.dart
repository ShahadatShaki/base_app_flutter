import 'package:base_app_flutter/base/BaseStatelessWidget.dart';
import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/controller/HostCalenderController.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HostCalenderPage extends BaseStatelessWidget {
  final HostCalenderController controller = Get.put(HostCalenderController());

  HostCalenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.getBlockDateList();
    return Scaffold(
        appBar: Component.appbar(name: "Select Dates"),
        body: Container(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 24),
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            color: AppColors.white,
            child: Column(
              children: [
                topBar(),
                Container(
                  height: 1,
                  color: AppColors.lineColor,
                  margin: EdgeInsets.only(top: 16, bottom: 16),
                ),
                Expanded(
                  // flex: 1,
                  child: Obx(() =>
                      controller.apiCalled.value ? showCalender() : margin(0)),
                ),
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
            )));
  }

  topBar() {
    return Row(
      // mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [],
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
      var item  = controller.blockDatesList[i];
      if (Constants.totalDays(date) ==
          Constants.totalDays(item)) {
        if(controller.blockDatesObjList[i].price.isNotEmpty){
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
      // monthViewSettings: DateRangePickerMonthViewSettings(
      //   specialDates: [
      //     DateTime(2023, 04, 20),
      //     DateTime(2020, 03, 16),
      //     DateTime(2020, 03, 17)
      //   ],
      // ),
      // monthCellStyle: DateRangePickerMonthCellStyle(
      //   specialDatesDecoration: BoxDecoration(
      //       color: Colors.green,
      //       border: Border.all(color: const Color(0xFF2B732F), width: 1),
      //       shape: BoxShape.circle),
      //   specialDatesTextStyle: const TextStyle(color: Colors.white),
      // ),
      cellBuilder: (context, cellDetails) {
        var bgcolor = dateInBlockDate(cellDetails.date);
        var isSelected = dateInSelectedDate(cellDetails.date);

        return Container(
          alignment: Alignment.center,
          decoration: isSelected
              ? BoxDecoration(shape: BoxShape.circle, color: AppColors.appColor)
              : BoxDecoration(
                      shape: BoxShape.rectangle, color: bgcolor),
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
