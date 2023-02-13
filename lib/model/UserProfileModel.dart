import 'package:base_app_flutter/model/ImageModel.dart';

import '../base/Serializable.dart';

class UserProfileModel implements Serializable {
  String? _id;
  String? _firstName;
  String? _lastName;
  String? _phone;
  String? _email;
  String? _birthdate;
  String? _referCode;
  String? _totalBooking;
  String? _averageResponse;
  String? _status;
  String? _osPlatform;
  String? _hostStatus;
  ImageModel? _image;

  UserProfileModel();

  String get id {
    _id ??= "";
    return _id!;
  }

  String get firstName {
    _firstName ??= "";
    return _firstName!;
  }

  String get lastName {
    _lastName ??= "";
    return _lastName!;
  }

  String get phone {
    _phone ??= "";
    return _phone!;
  }

  String get email {
    _email ??= "";
    return _email!;
  }

  String get birthdate {
    _birthdate ??= "";
    return _birthdate!;
  }

  String get referCode {
    _referCode ??= "";
    return _referCode!;
  }

  String get totalBooking {
    _totalBooking ??= "";
    return _totalBooking!;
  }

  String get averageResponse {
    _averageResponse ??= "";
    return _averageResponse!;
  }

  String get status {
    _status ??= "";
    return _status!;
  }

  String get osPlatform {
    _osPlatform ??= "";
    return _osPlatform!;
  }

  String get hostStatus {
    _hostStatus ??= "";
    return _hostStatus!;
  }

  ImageModel get image {
    _image ??= ImageModel();
    return _image!;
  }

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _firstName = json['first_name'].toString();
    _lastName = json['last_name'].toString();
    _phone = json['phone'].toString();
    _email = json['email'].toString();
    _birthdate = json['birthdate'].toString();
    _referCode = json['refer_code'].toString();
    _totalBooking = json['total_booking'].toString();
    _averageResponse = json['average_response'].toString();
    _status = json['status'].toString();
    _osPlatform = json['os_platform'].toString();
    _image = json['image'] != null
        ? ImageModel.fromJson(json['image'])
        : ImageModel();
    _hostStatus = json['host_status'].toString();
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
    data['image'] = image.toJson();
    data['host_status'] = hostStatus;
    return data;
  }
}
