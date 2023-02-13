import 'package:base_app_flutter/utility/Constrants.dart';

import '../base/Serializable.dart';

class LocationModel implements Serializable {
  String? _name;
  String? _lat;
  String? _lng;
  String? _count;
  String? _day;
  String? _id;

  String get name {
    _name ??= "";
    return _name!;
  }

  String get lat {
    _lat ??= "";
    return _lat!;
  }

  String get lng {
    _lng ??= "";
    return _lng!;
  }

  String get count {
    _count ??= "";
    return _count!;
  }

  String get day {
    _day ??= "";
    return _day!;
  }

  String get id {
    _id ??= "";
    return _id!;
  }

  getName() {
    return Constants.capitalizeWords(name!);
  }

  LocationModel();

  LocationModel.fromJson(Map<String, dynamic> json) {
    _name = json['name'].toString();
    _lat = json['lat'].toString();
    _lng = json['lng'].toString();
    _count = json['count'].toString();
    _day = json['new'].toString();
    _id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['count'] = this.count;
    data['new'] = this.day;
    data['id'] = this.id;
    return data;
  }
}
