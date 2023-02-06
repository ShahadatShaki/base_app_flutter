import 'package:base_app_flutter/model/ImageModel.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:flutter/material.dart';

import '../base/Serializable.dart';
import 'Cancellation.dart';
import 'PropertyType.dart';

class ListingModel implements Serializable {
  int? id;
  String? title;
  String? placeType;
  String? address;
  int? maxGuest;
  int? maxChild;
  int? maxInfant;
  int? minNights;
  int? freeGuest;
  int? bedroom;
  dynamic beds;
  dynamic bathroom;
  int? price;
  int? weekendPrice;
  int? perGuestAmount;
  String? checkIn;
  String? checkOut;
  String? description;
  String? createdAt;
  dynamic averageRating;
  dynamic averageResponse;
  int? totalAverage;
  int? commissionRate;
  String? commissionExpiredDate;
  int? customCommission;
  String? instantBookingType;
  String? instantBookingFrom;
  String? instantBookingTo;
  String? instantBookingMessage;
  int? totalCount;
  int? showablePrice;
  String? type;
  String? advance;
  int? commission;
  int? beforeDiscount;
  int? averagePrice;
  Location? location;
  PropertyType? propertyType;
  String? status;
  List<ImageModel>? images;
  UserProfileModel? host;
  int? reviewsCount;
  dynamic reviewsAvg;
  Cancellation? cancellation;
  dynamic hotel;
  int sliderCurrentPosition = 0;

  ScrollController itemScrollController = ScrollController();


  ListingModel();

  int getCurrentPrice() {
    return averagePrice == 0 ? price! : averagePrice!;
  }

  ListingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    placeType = json['place_type'];
    address = json['address'];
    maxGuest = json['max_guest'];
    maxChild = json['max_child'];
    maxInfant = json['max_infant'];
    minNights = json['min_nights'];
    freeGuest = json['free_guest'];
    bedroom = json['bedroom'];
    beds = json['beds'];
    bathroom = json['bathroom'];
    price = json['price'];
    weekendPrice = json['weekend_price'];
    perGuestAmount = json['per_guest_amount'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    description = json['description'];
    createdAt = json['created_at'];
    averageRating = json['average_rating'];
    averageResponse = json['average_response'];
    totalAverage = json['total_average'];
    commissionRate = json['commission_rate'];
    commissionExpiredDate = json['commission_expired_date'];
    customCommission = json['custom_commission'];
    instantBookingType = json['instant_booking_type'];
    instantBookingFrom = json['instant_booking_from'];
    instantBookingTo = json['instant_booking_to'];
    instantBookingMessage = json['instant_booking_message'];
    totalCount = json['total_count'];
    showablePrice = json['showable_price'];
    type = json['type'];
    advance = json['advance'];
    commission = json['commission'];
    beforeDiscount = json['before_discount'];
    averagePrice = json['average_price'] ?? 0;
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    propertyType = json['property_type'] != null
        ? PropertyType.fromJson(json['property_type'])
        : null;
    status = json['status'];
    if (json['images'] != null) {
      images = <ImageModel>[];
      json['images'].forEach((v) {
        images?.add(ImageModel.fromJson(v));
      });
    }
    host =
        json['host'] != null ? UserProfileModel.fromJson(json['host']) : null;
    reviewsCount = json['reviews_count'];
    reviewsAvg = json['reviews_avg'];
    cancellation = json['cancellation'] != null
        ? new Cancellation.fromJson(json['cancellation'])
        : null;
    hotel = json['hotel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['place_type'] = this.placeType;
    data['address'] = this.address;
    data['max_guest'] = this.maxGuest;
    data['max_child'] = this.maxChild;
    data['max_infant'] = this.maxInfant;
    data['min_nights'] = this.minNights;
    data['free_guest'] = this.freeGuest;
    data['bedroom'] = this.bedroom;
    data['beds'] = this.beds;
    data['bathroom'] = this.bathroom;
    data['price'] = this.price;
    data['weekend_price'] = this.weekendPrice;
    data['per_guest_amount'] = this.perGuestAmount;
    data['check_in'] = this.checkIn;
    data['check_out'] = this.checkOut;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['average_rating'] = this.averageRating;
    data['average_response'] = this.averageResponse;
    data['total_average'] = this.totalAverage;
    data['commission_rate'] = this.commissionRate;
    data['commission_expired_date'] = this.commissionExpiredDate;
    data['custom_commission'] = this.customCommission;
    data['instant_booking_type'] = this.instantBookingType;
    data['instant_booking_from'] = this.instantBookingFrom;
    data['instant_booking_to'] = this.instantBookingTo;
    data['instant_booking_message'] = this.instantBookingMessage;
    data['total_count'] = this.totalCount;
    data['showable_price'] = this.showablePrice;
    data['type'] = this.type;
    data['advance'] = this.advance;
    data['commission'] = this.commission;
    data['before_discount'] = this.beforeDiscount;
    data['average_price'] = this.averagePrice;
    if (this.location != null) {
      data['location'] = this.location?.toJson();
    }
    if (this.propertyType != null) {
      data['property_type'] = this.propertyType?.toJson();
    }
    data['status'] = this.status;
    if (this.images != null) {
      data['images'] = this.images?.map((v) => v.toJson()).toList();
    }
    if (this.host != null) {
      data['host'] = this.host?.toJson();
    }
    data['reviews_count'] = this.reviewsCount;
    data['reviews_avg'] = this.reviewsAvg;
    if (this.cancellation != null) {
      data['cancellation'] = this.cancellation?.toJson();
    }
    data['hotel'] = this.hotel;
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
