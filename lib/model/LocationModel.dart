import 'package:base_app_flutter/utility/Constrants.dart';

import '../base/Serializable.dart';

class LocationModel implements Serializable {
  String? name;
  dynamic lat;
  dynamic lng;
  dynamic count;
  dynamic day;
  dynamic id;

  getName() {
    return Constants.capitalizeWords(name!);
  }

  LocationModel({
    this.name,
    this.lat,
    this.lng,
    this.count,
    this.day,
    this.id,
  });

  LocationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    lat = json['lat'];
    lng = json['lng'];
    count = json['count'];
    day = json['new'];
    id = json['id'];
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
