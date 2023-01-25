import 'package:base_app_flutter/utility/Constrants.dart';

class SearchOptions {
  String name = "";
  dynamic lat;
  dynamic lng;
  DateTime? checkinDateCalender;
  DateTime? checkoutDateCalender;
  String checkinDate = "";
  String checkoutDate = "";
  int guestCount = 0;
  int childCount = 0;
  int infantCount = 0;

  dynamic dayDiff() {
    if (checkinDateCalender != null && checkoutDateCalender != null) {
      return Constants.totalDays(checkoutDateCalender!) -
          Constants.totalDays(checkinDateCalender!);
    } else
      return 0;
    //
    // return checkinDate;
  }

  dynamic getCheckinCheckoutDate() {
    return checkinDate.isNotEmpty ? "${checkinDate} - ${checkoutDate}" : "";
  }

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
}
