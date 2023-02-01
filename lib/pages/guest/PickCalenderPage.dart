import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/model/SearchOptions.dart';
import 'package:base_app_flutter/utility/AppColors.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PickCalenderPage extends StatefulWidget {
  SearchOptions searchOptions;

  PickCalenderPage({required this.searchOptions, Key? key}) : super(key: key);

  @override
  State<PickCalenderPage> createState() =>
      _PickCalender(searchOptions: searchOptions);
}

class _PickCalender extends State<PickCalenderPage> {
  SearchOptions searchOptions;
  late SearchOptions damiSearchOptions;

  _PickCalender({required this.searchOptions, Key? key}){
    damiSearchOptions = searchOptions.clone();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: Component.appbar(name: "Select Dates"),
        body: Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 24),
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
                  child: SfDateRangePicker(
                    navigationMode: DateRangePickerNavigationMode.scroll,
                    minDate: DateTime.now(),
                    navigationDirection:
                        DateRangePickerNavigationDirection.vertical,
                    onSelectionChanged: _onSelectionChanged,
                    enableMultiView: true,
                    selectionMode: DateRangePickerSelectionMode.range,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextButton(
                  style: Component.textButtonStyle(),
                  onPressed: () {
                    searchOptions = damiSearchOptions;
                    Get.back(result: searchOptions);
                  },
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
      children: [
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Check In",
                  style: TextStyle(fontSize: 12, color: AppColors.darkGray)),
              Text(
                  damiSearchOptions.checkinDateCalender == null
                      ? "Check In"
                      : Constants.calenderToString(damiSearchOptions.checkinDateCalender!, "dd MMM, yyyy"),
                  style:
                      TextStyle(fontSize: 16, color: AppColors.textColorBlack)),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
            decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.lightestLineColor,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Text(
              "${damiSearchOptions.dayDiff()}\nNight",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.appColor, fontSize: 12),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const Text("Check In",
                  style: TextStyle(fontSize: 12, color: AppColors.darkGray)),
              Text(
                  damiSearchOptions.checkoutDateCalender == null
                      ? "Check Out"
                      : Constants.calenderToString(damiSearchOptions.checkoutDateCalender!, "dd MMM, yyyy") ,
                  style: const TextStyle(
                      fontSize: 16, color: AppColors.textColorBlack)),
            ],
          ),
        )
      ],
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // inspect(dateRangePickerSelectionChangedArgs);
    if (args.value is PickerDateRange) {
      setState(() {
        // damiSearchOptions.checkinDate =
        //     '${DateFormat('dd MMM, yyyy').format(args.value.startDate)}';
        // damiSearchOptions.checkoutDate =
        //     ' ${DateFormat('dd MMM, yyyy').format(args.value.endDate ?? args.value.startDate)}';
        damiSearchOptions.checkinDateCalender = args.value.startDate;
        damiSearchOptions.checkoutDateCalender = args.value.endDate;
      });
    }
  }
}
