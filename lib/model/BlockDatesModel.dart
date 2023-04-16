import 'package:base_app_flutter/utility/Constrants.dart';

import '../base/Serializable.dart';

class BlockDatesModel implements Serializable {
  String? _id;
  String? _date;
  String? _count;
  String? _price;

  String get id {
    _id ??= "";
    return _id!;
  }

  String get date {
    _date ??= "";
    return _date!;
  }

  String get count {
    _count ??= "";
    return _count!;
  }

  String get price {
    _price ??= "";
    if (_price == "null") _price = "";
    return _price!;
  }

  DateTime dateCalendar() {
    return Constants.stingToCalender(date);
  }

  BlockDatesModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _count = json['count'].toString();
    _date = json['date'].toString();
    _price = json['price'].toString();
  }

  Map<String, dynamic> toJson() => {
        "id": this.id,
        "count": this.count,
        "date": this.date,
        "price": this.price,
      };
}
