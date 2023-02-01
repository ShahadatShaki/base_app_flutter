import 'package:base_app_flutter/model/ImageModel.dart';

import '../base/Serializable.dart';

class UserProfileModel implements Serializable {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? birthdate;
  String? referCode;
  int? totalBooking;
  int? averageResponse;
  int? status;
  int? osPlatform;
  ImageModel? image;
  String? hostStatus;

  UserProfileModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.phone,
        this.email,
        this.birthdate,
        this.referCode,
        this.totalBooking,
        this.averageResponse,
        this.status,
        this.osPlatform,
        this.image,
        this.hostStatus});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    birthdate = json['birthdate'];
    referCode = json['refer_code'];
    totalBooking = json['total_booking'];
    averageResponse = json['average_response'];
    status = json['status'];
    osPlatform = json['os_platform'];
    image = json['image'] != null ? new ImageModel.fromJson(json['image']) : null;
    hostStatus = json['host_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['birthdate'] = this.birthdate;
    data['refer_code'] = this.referCode;
    data['total_booking'] = this.totalBooking;
    data['average_response'] = this.averageResponse;
    data['status'] = this.status;
    data['os_platform'] = this.osPlatform;
    if (this.image != null) {
      data['image'] = this.image?.toJson();
    }
    data['host_status'] = this.hostStatus;
    return data;
  }
}

