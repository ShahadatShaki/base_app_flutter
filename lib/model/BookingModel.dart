import 'package:base_app_flutter/model/ImageModel.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/Constrants.dart';

import '../base/Serializable.dart';

class BookingModel implements Serializable {
  String? _id;
  String? _formattedId;
  String? _from;
  String? _to;
  String? _totalGuest;
  String? _price;
  String? _commission;
  String? _discount;
  String? _moreNightsDiscount;
  String? _totalPayable;
  String? _extraGuestCharge;
  String? _serviceFee;
  String? _paid;
  String? _status;
  String? _createdAt;
  String? _statusUpdatedAt;
  String? _osPlatform;
  List<Null>? _reviews;
  UserProfileModel? _guest;
  UserProfileModel? _host;
  ListingModel? _listing;
  List<ImageModel>? _images;

  BookingModel();

  String get id {
    _id ??= "";
    return _id!;
  }

  String get formattedId {
    _formattedId ??= "";
    return _formattedId!;
  }

  String get from {
    _from ??= "";
    return _from!;
  }

  String get to {
    _to ??= "";
    return _to!;
  }

  String get totalGuest {
    _totalGuest ??= "";
    return _totalGuest!;
  }

  String get price {
    _price ??= "";
    return _price!;
  }

  String get commission {
    _commission ??= "";
    return _commission!;
  }

  String get discount {
    _discount ??= "";
    return _discount!;
  }

  String get moreNightsDiscount {
    _moreNightsDiscount ??= "";
    return _moreNightsDiscount!;
  }

  String get totalPayable {
    _totalPayable ??= "";
    return _totalPayable!;
  }

  String get extraGuestCharge {
    _extraGuestCharge ??= "";
    return _extraGuestCharge!;
  }

  String get serviceFee {
    _serviceFee ??= "";
    return _serviceFee!;
  }

  String get paid {
    _paid ??= "";
    return _paid!;
  }

  String get status {
    _status ??= "";
    return _status!;
  }

  String get createdAt {
    _createdAt ??= "";
    return _createdAt!;
  }

  String get statusUpdatedAt {
    _statusUpdatedAt ??= "";
    return _statusUpdatedAt!;
  }

  String get osPlatform {
    _osPlatform ??= "";
    return _osPlatform!;
  }

  List<Null> get reviews {
    _reviews ??= [];
    return _reviews!;
  }

  UserProfileModel get guest {
    _guest ??= UserProfileModel();
    return _guest!;
  }

  UserProfileModel get host {
    _host ??= UserProfileModel();
    return _host!;
  }

  ListingModel get listing {
    _listing ??= ListingModel();
    return _listing!;
  }

  List<ImageModel> get images {
    _images ??= [];
    return _images!;
  }

  bool isExpire() {
    var _expire = false;

    return _expire;
  }

  DateTime calenderTo() {
    try {
      DateTime date = DateTime.parse(to);
      return date;
    } catch (e) {
      return DateTime.now();
    }
  }

  DateTime calenderFrom() {
    try {
      DateTime date = DateTime.parse(from);
      return date;
    } catch (e) {
      print(e);
      return DateTime.now();
    }
  }

  String fromToStrForShow() {
    return "${Constants.calenderToString(calenderFrom(), "dd MMM")} - ${Constants.calenderToString(calenderTo(), "dd MMM")}";
  }

  BookingModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _formattedId = json['formatted_id'].toString();
    _guest = json['guest'] != null
        ? new UserProfileModel.fromJson(json['guest'])
        : null;
    _host = json['host'] != null
        ? new UserProfileModel.fromJson(json['host'])
        : null;
    _listing = json['listing'] != null
        ? new ListingModel.fromJson(json['listing'])
        : null;
    if (json['images'] != null) {
      _images = <ImageModel>[];
      json['images'].forEach((v) {
        images!.add(new ImageModel.fromJson(v));
      });
    }
    _from = json['from'].toString();
    _to = json['to'].toString();
    _totalGuest = json['total_guest'].toString();
    _price = json['price'].toString();
    _commission = json['commission'].toString();
    _discount = json['discount'].toString();
    _moreNightsDiscount = json['more_nights_discount'].toString();
    _totalPayable = json['total_payable'].toString();
    _extraGuestCharge = json['extra_guest_charge'].toString();
    _serviceFee = json['service_fee'].toString();
    _paid = json['paid'].toString();
    _status = json['status'].toString();
    _createdAt = json['created_at'].toString();
    // if (json['reviews'] != null) {
    //   reviews = <Null>[];
    //   json['reviews'].forEach((v) {
    //     reviews!.add(new Null.fromJson(v));
    //   });
    // }
    _statusUpdatedAt = json['status_updated_at'].toString();
    _osPlatform = json['os_platform'].toString();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'formatted_id': formattedId,
        'guest': guest?.toJson(),
        'host': host?.toJson(),
        'listing': listing?.toJson(),
        'images': images?.map((e) => e.toJson()).toList(),
        'from': from,
        'to': to,
        'total_guest': totalGuest,
        'price': price,
        'commission': commission,
        'discount': discount,
        'more_nights_discount': moreNightsDiscount,
        'total_payable': totalPayable,
        'extra_guest_charge': extraGuestCharge,
        'service_fee': serviceFee,
        'paid': paid,
        'status': status,
        'created_at': createdAt,
        // 'reviews': reviews,
        'status_updated_at': statusUpdatedAt,
        'os_platform': osPlatform
      };
}
