import 'package:base_app_flutter/model/ImageModel.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/Constrants.dart';

import '../base/Serializable.dart';

class BookingModel implements Serializable {
  String? id;
  String? formattedId;
  UserProfileModel? guest;
  UserProfileModel? host;
  ListingModel? listing;
  List<ImageModel>? images;
  String? from;
  String? to;
  String? totalGuest;
  String? price;
  String? commission;
  String? discount;
  String? moreNightsDiscount;
  String? totalPayable;
  String? extraGuestCharge;
  String? serviceFee;
  String? paid;
  String? status;
  String? createdAt;
  List<Null>? reviews;
  String? statusUpdatedAt;
  String? osPlatform;

  BookingModel();

  DateTime calenderTo() {
    DateTime date = DateTime.parse(to!);
    return date;
  }
  DateTime calenderFrom() {
    DateTime date = DateTime.parse(from!);
    return date;
  }

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    formattedId = json['formatted_id'].toString();
    guest = json['guest'] != null
        ? new UserProfileModel.fromJson(json['guest'])
        : null;
    host = json['host'] != null
        ? new UserProfileModel.fromJson(json['host'])
        : null;
    listing = json['listing'] != null
        ? new ListingModel.fromJson(json['listing'])
        : null;
    if (json['images'] != null) {
      images = <ImageModel>[];
      json['images'].forEach((v) {
        images!.add(new ImageModel.fromJson(v));
      });
    }
    from = json['from'].toString();
    to = json['to'].toString();
    totalGuest = json['total_guest'].toString();
    price = json['price'].toString();
    commission = json['commission'].toString();
    discount = json['discount'].toString();
    moreNightsDiscount = json['more_nights_discount'].toString();
    totalPayable = json['total_payable'].toString();
    extraGuestCharge = json['extra_guest_charge'].toString();
    serviceFee = json['service_fee'].toString();
    paid = json['paid'].toString();
    status = json['status'].toString();
    createdAt = json['created_at'].toString();
    // if (json['reviews'] != null) {
    //   reviews = <Null>[];
    //   json['reviews'].forEach((v) {
    //     reviews!.add(new Null.fromJson(v));
    //   });
    // }
    statusUpdatedAt = json['status_updated_at'].toString();
    osPlatform = json['os_platform'].toString();
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
