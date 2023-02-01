import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:intl/intl.dart';

class SearchOptions {
  String name = "";
  dynamic lat;
  dynamic lng;
  DateTime? checkinDateCalender;
  DateTime? checkoutDateCalender;
  int guestCount = 0;
  int childCount = 0;
  int infantCount = 0;

  SearchOptions();

  clone() {
    SearchOptions options = SearchOptions();
    var jsonString = toJson();
    options = SearchOptions.fromJson(jsonString);
    return options;
  }

  SearchOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    checkinDateCalender = json['checkinDateCalender'];
    checkoutDateCalender = json['checkoutDateCalender'];
    // checkinDate = json['checkinDate'];
    // checkoutDate = json['checkoutDate'];
    guestCount = json['guestCount'];
    childCount = json['childCount'];
    infantCount = json['infantCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['name'] = name;
    data['lat'] = lat;
    data['lng'] = lng;
    data['checkinDateCalender'] = checkinDateCalender;
    data['checkoutDateCalender'] = checkoutDateCalender;
    // data['checkinDate'] = checkinDate;
    // data['checkoutDate'] = checkoutDate;
    data['guestCount'] = guestCount;
    data['childCount'] = childCount;
    data['infantCount'] = infantCount;
    return data;
  }

  dynamic dayDiff() {
    if (checkinDateCalender != null && checkoutDateCalender != null) {
      return Constants.totalDays(checkoutDateCalender!) -
          Constants.totalDays(checkinDateCalender!);
    } else
      return 0;
    //
    // return checkinDate;
  }

  // checkinDate ='${DateFormat('dd MMM, yyyy').format(args.value.startDate)}';

  String getCheckinCheckoutShortDate() {
    return checkoutDateCalender != null
        ? "${Constants.calenderToString(checkinDateCalender!, "dd MMM")} - ${Constants.calenderToString(checkoutDateCalender!, "dd MMM")}"
        : "";
  }

  // dynamic getCheckinCheckoutShortDate() {
  //   return checkinDate.isNotEmpty
  //       ? "${DateFormat('MMM dd').format(checkinDateCalender!)} - ${DateFormat('MMM dd').format(checkoutDateCalender!)}"
  //       : "";
  // }

  String getGuestCounts() {
    String result = "";
    if (guestCount > 0) {
      result += "$guestCount Adults, ";
    }
    if (childCount > 0) {
      result += "$childCount Childes, ";
    }
    if (infantCount > 0) {
      result += "$infantCount Infants";
    }

    return result;
  }

  String getCount(String title) {
    if (title == "Adults") {
      return guestCount.toString();
    }
    if (title == "Child") {
      return childCount.toString();
    } else {
      return infantCount.toString();
    }
  }

  void changeCount(String title, int i) {
    if (title == "Adults") {
      guestCount += i;
      if (guestCount < 0) {
        guestCount = 0;
      }
    } else if (title == "Child") {
      childCount += i;
      if (childCount < 0) {
        childCount = 0;
      }
    } else {
      infantCount += i;
      if (infantCount < 0) {
        infantCount = 0;
      }
    }
  }

  String getName() {
    return name;
  }
}
