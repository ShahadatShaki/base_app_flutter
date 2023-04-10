import 'package:base_app_flutter/model/ImageModel.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';

import '../base/Serializable.dart';
import 'Cancellation.dart';
import 'PropertyType.dart';

class ListingModel implements Serializable {
  String? _id;
  String? _title;
  String? _placeType;
  String? _address;
  String? _maxGuest;
  String? _maxChild;
  String? _maxInfant;
  String? _minNights;
  String? _freeGuest;
  String? _bedroom;
  String? _beds;
  String? _bathroom;
  String? _price;
  String? _weekendPrice;
  String? _perGuestAmount;
  String? _checkIn;
  String? _checkOut;
  String? _description;
  String? _createdAt;
  String? _averageRating;
  String? _averageResponse;
  String? _totalAverage;
  String? _commissionRate;
  String? _commissionExpiredDate;
  String? _customCommission;
  String? _instantBookingType;
  String? _instantBookingFrom;
  String? _instantBookingTo;
  String? _instantBookingMessage;
  String? _totalCount;
  String? _showablePrice;
  String? _type;
  String? _advance;
  String? _commission;
  String? _beforeDiscount;
  String? _averagePrice;
  String? _status;
  Location? _location;
  PropertyType? _propertyType;
  List<ImageModel>? _images;
  UserProfileModel? _host;
  String? _reviewsCount;
  String? _reviewsAvg;
  Cancellation? _cancellation;
  dynamic hotel;

  int sliderCurrentPosition = 0;

  ScrollController itemScrollController = ScrollController();

  ListingModel();

  String get id {
    _id ??= "";
    return _id!;
  }

  String get title {
    _title ??= "";
    return _title!;
  }

  String get placeType {
    _placeType ??= "";
    return _placeType!;
  }

  String get address {
    _address ??= "";
    return _address!;
  }

  String get maxGuest {
    _maxGuest ??= "";
    return _maxGuest!;
  }

  String get maxChild {
    _maxChild ??= "";
    return _maxChild!;
  }

  String get maxInfant {
    _maxInfant ??= "";
    return _maxInfant!;
  }

  String get minNights {
    _minNights ??= "";
    return _minNights!;
  }

  String get freeGuest {
    _freeGuest ??= "";
    return _freeGuest!;
  }

  String get bedroom {
    _bedroom ??= "";
    return _bedroom!;
  }

  String get beds {
    _beds ??= "";
    return _beds!;
  }

  String get bathroom {
    _bathroom ??= "";
    return _bathroom!;
  }

  String get price {
    _price ??= "0";
    return _price!;
  }

  String get weekendPrice {
    _weekendPrice ??= "";
    return _weekendPrice!;
  }

  String get perGuestAmount {
    _perGuestAmount ??= "";
    return _perGuestAmount!;
  }

  String get checkIn {
    _checkIn ??= "";
    return _checkIn!;
  }

  String get checkOut {
    _checkOut ??= "";
    return _checkOut!;
  }

  String get description {
    _description ??= "";
    return _description!;
  }

  String get createdAt {
    _createdAt ??= "";
    return _createdAt!;
  }

  String get averageRating {
    _averageRating ??= "";
    return _averageRating!;
  }

  String get averageResponse {
    _averageResponse ??= "";
    return _averageResponse!;
  }

  String get totalAverage {
    _totalAverage ??= "";
    return _totalAverage!;
  }

  String get commissionRate {
    _commissionRate ??= "";
    return _commissionRate!;
  }

  String get commissionExpiredDate {
    _commissionExpiredDate ??= "";
    return _commissionExpiredDate!;
  }

  String get customCommission {
    _customCommission ??= "";
    return _customCommission!;
  }

  String get instantBookingType {
    _instantBookingType ??= "";
    return _instantBookingType!;
  }

  String get instantBookingFrom {
    _instantBookingFrom ??= "";
    return _instantBookingFrom!;
  }

  String get instantBookingTo {
    _instantBookingTo ??= "";
    return _instantBookingTo!;
  }

  String get instantBookingMessage {
    _instantBookingMessage ??= "";
    return _instantBookingMessage!;
  }

  String get totalCount {
    _totalCount ??= "";
    return _totalCount!;
  }

  String get showablePrice {
    _showablePrice ??= "";
    return _showablePrice!;
  }

  String get type {
    _type ??= "";
    return _type!;
  }

  String get advance {
    _advance ??= "";
    return _advance!;
  }

  String get commission {
    _commission ??= "";
    return _commission!;
  }

  String get beforeDiscount {
    _beforeDiscount ??= "";
    return _beforeDiscount!;
  }

  String get averagePrice {
    _averagePrice ??= "0";
    return _averagePrice!;
  }

  String get status {
    _status ??= "";
    return _status!;
  }

  Location get location {
    _location ??= Location();
    return _location!;
  }

  PropertyType get propertyType {
    _propertyType ??= PropertyType();
    return _propertyType!;
  }

  List<ImageModel> get images {
    _images ??= [];
    return _images!;
  }

  UserProfileModel get host {
    _host ??= UserProfileModel();
    return _host!;
  }

  String get reviewsCount {
    _reviewsCount ??= "";
    return _reviewsCount!;
  }

  String get reviewsAvg {
    _reviewsAvg ??= "";
    return _reviewsAvg!;
  }

  Cancellation get cancellation {
    _cancellation ??= Cancellation();
    return _cancellation!;
  }

  getPrice() {
    return int.parse(_price!);
  }

  String getCoverImage() {
    return images.isNotEmpty ? images[0].url : "";
  }

  int getCurrentPrice() {
    return averagePrice == "0" ? int.parse(price) : int.parse(averagePrice);
  }

  bool isInstantBookingEnableNow() {
    if (instantBookingType == "ALWAYS") {
      return true;
    } else if (instantBookingType == "CUSTOM") {
      DateTime calendar = DateTime.now();
      DateTime startTime = Constants.stingToCalender(instantBookingFrom);
      DateTime endTime = Constants.stingToCalender(instantBookingTo);

      int start = (startTime.hour * 60) + startTime.minute;
      int end = (endTime.hour * 60) + endTime.minute;
      int now = (calendar.hour * 60) + calendar.minute;
      return now > start && now < end;
    } else {
      return false;
    }
  }

  ListingModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _title = json['title'].toString();
    _placeType = json['place_type'].toString();
    _address = json['address'].toString();
    _maxGuest = json['max_guest'].toString();
    _maxChild = json['max_child'].toString();
    _maxInfant = json['max_infant'].toString();
    _minNights = json['min_nights'].toString();
    _freeGuest = json['free_guest'].toString();
    _bedroom = json['bedroom'].toString();
    _beds = json['beds'].toString();
    _bathroom = json['bathroom'].toString();
    _price = json['price'].toString();
    _weekendPrice = json['weekend_price'].toString();
    _perGuestAmount = json['per_guest_amount'].toString();
    _checkIn = json['check_in'].toString();
    _checkOut = json['check_out'].toString();
    _description = json['description'].toString();
    _createdAt = json['created_at'].toString();
    _averageRating = json['average_rating'].toString();
    _averageResponse = json['average_response'].toString();
    _totalAverage = json['total_average'].toString();
    _commissionRate = json['commission_rate'].toString();
    _commissionExpiredDate = json['commission_expired_date'].toString();
    _customCommission = json['custom_commission'].toString();
    _instantBookingType = json['instant_booking_type'].toString();
    _instantBookingFrom = json['instant_booking_from'].toString();
    _instantBookingTo = json['instant_booking_to'].toString();
    _instantBookingMessage = json['instant_booking_message'].toString();
    _totalCount = json['total_count'].toString();
    _showablePrice = json['showable_price'].toString();
    _type = json['type'].toString();
    _advance = json['advance'].toString();
    _commission = json['commission'].toString();
    _beforeDiscount = json['before_discount'].toString();
    _averagePrice = json['average_price'] ?? "0";
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    _propertyType = json['property_type'] != null
        ? PropertyType.fromJson(json['property_type'])
        : null;
    _status = json['status'].toString();
    if (json['images'] != null) {
      _images = <ImageModel>[];
      json['images'].forEach((v) {
        _images!.add(ImageModel.fromJson(v));
      });
    } else {
      _images = [];
    }
    _host =
        json['host'] != null ? UserProfileModel.fromJson(json['host']) : null;
    _reviewsCount = json['reviews_count'].toString();
    _reviewsAvg = json['reviews_avg'].toString();
    _cancellation = json['cancellation'] != null
        ? new Cancellation.fromJson(json['cancellation'])
        : null;
    hotel = json['hotel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['place_type'] = placeType;
    data['address'] = address;
    data['max_guest'] = maxGuest;
    data['max_child'] = maxChild;
    data['max_infant'] = maxInfant;
    data['min_nights'] = minNights;
    data['free_guest'] = freeGuest;
    data['bedroom'] = bedroom;
    data['beds'] = beds;
    data['bathroom'] = bathroom;
    data['price'] = _price;
    data['weekend_price'] = weekendPrice;
    data['per_guest_amount'] = perGuestAmount;
    data['check_in'] = checkIn;
    data['check_out'] = checkOut;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['average_rating'] = averageRating;
    data['average_response'] = averageResponse;
    data['total_average'] = totalAverage;
    data['commission_rate'] = commissionRate;
    data['commission_expired_date'] = commissionExpiredDate;
    data['custom_commission'] = customCommission;
    data['instant_booking_type'] = instantBookingType;
    data['instant_booking_from'] = instantBookingFrom;
    data['instant_booking_to'] = instantBookingTo;
    data['instant_booking_message'] = instantBookingMessage;
    data['total_count'] = totalCount;
    data['showable_price'] = showablePrice;
    data['type'] = type;
    data['advance'] = advance;
    data['commission'] = commission;
    data['before_discount'] = beforeDiscount;
    data['average_price'] = averagePrice;
    if (location != null) {
      data['location'] = location.toJson();
    }
    if (propertyType != null) {
      data['property_type'] = propertyType.toJson();
    }
    data['status'] = status;
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    if (host != null) {
      data['host'] = host.toJson();
    }
    data['reviews_count'] = reviewsCount;
    data['reviews_avg'] = reviewsAvg;
    if (cancellation != null) {
      data['cancellation'] = cancellation.toJson();
    }
    data['hotel'] = hotel;
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({lat, lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
