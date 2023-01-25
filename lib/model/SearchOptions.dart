
import 'package:base_app_flutter/utility/Constrants.dart';

import '../base/Serializable.dart';

class SearchOptions{
  String name = "";
  dynamic lat;
  dynamic lng;
  DateTime? checkinDateCalender;
  DateTime? checkoutDateCalender;
  String checkinDate = "";
  String checkoutDate = "";
  int guestCount = 0;


  dynamic dayDiff(){
    if(checkinDateCalender !=null && checkoutDateCalender !=null){
      return Constants.totalDays(checkoutDateCalender!) - Constants.totalDays(checkinDateCalender!);
    }else
      return 0;
    //
    // return checkinDate;
  }




}
