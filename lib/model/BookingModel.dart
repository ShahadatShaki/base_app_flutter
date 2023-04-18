import 'package:base_app_flutter/model/ImageModel.dart';
import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/model/ReviewModel.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:base_app_flutter/utility/SharedPref.dart';

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
  String? _amount;
  String? _status;
  String? _createdAt;
  String? _paymentUrl;
  String? _statusUpdatedAt;
  String? _osPlatform;
  bool? _is_expire;
  List<ReviewModel>? _reviews;
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

  String get paymentUrl {
    _paymentUrl ??= "";
    return _paymentUrl!;
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

  int get minimumPayableAmount {
    _amount ??= "0";
    if (_amount == "null") _amount = "0";
    return int.parse(_amount!);
  }

  set minimumPayableAmount(amount) {
    _amount = amount.toString();
  }

  String get commission {
    _commission ??= "";
    return _commission!;
  }

  String get discount {
    _discount ??= "0";
    return _discount!;
  }

  String get moreNightsDiscount {
    _moreNightsDiscount ??= "0";
    return _moreNightsDiscount!;
  }

  int get totalPayable {
    _totalPayable ??= "0";
    return int.parse(_totalPayable!);
  }

  String get extraGuestCharge {
    _extraGuestCharge ??= "";
    return _extraGuestCharge!;
  }

  int get serviceFee {
    _serviceFee ??= "0";
    return int.parse(_serviceFee!);
  }

  int get paid {
    _paid ??= "0";
    return int.parse(_paid!);
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

  bool get isExpire {
    _is_expire ??= false;
    var isCheckinDateExpired = Constants.totalDays(calenderCheckin()) <=
        Constants.totalDays(DateTime.now());
    return _is_expire! || isCheckinDateExpired;
  }

  String get osPlatform {
    _osPlatform ??= "";
    return _osPlatform!;
  }

  List<ReviewModel> get reviews {
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

  int getAllDiscount() {
    int dis = int.parse(moreNightsDiscount) + int.parse(discount);
    return dis;
  }

  DateTime calenderCheckout() {
    try {
      DateTime date = DateTime.parse(to);

      return DateTime(date.year, date.month, date.day + 1);
    } catch (e) {
      return DateTime.now();
    }
  }

  bool isRequested() {
    return status.toLowerCase() == "requested";
  }

  bool isConfirmed() {
    return status.toLowerCase() == "confirmed";
  }

  bool isAccepted() {
    return status.toLowerCase() == "accepted";
  }

  bool isRejected() {
    return status.toLowerCase() == "rejected";
  }

  bool isPartial() {
    return status.toLowerCase() == "partial";
  }

  DateTime calenderCheckin() {
    try {
      DateTime date = DateTime.parse(from);
      return date;
    } catch (e) {
      print(e);
      return DateTime.now();
    }
  }

  String fromToStrForShow() {
    return "${Constants.calenderToString(calenderCheckin(), "dd MMM")} - ${Constants.calenderToString(calenderCheckout(), "dd MMM")}";
  }

  String fromShortStrForShow({String format = "dd MMM"}) {
    return Constants.calenderToString(calenderCheckin(), format);
  }

  String toShortStrForShow({String format = "dd MMM"}) {
    return Constants.calenderToString(calenderCheckout(), format);
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
    _paymentUrl = json['payment_url'].toString();
    _amount = json['amount'].toString();
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
    _is_expire = json['is_expire'];
    _createdAt = json['created_at'].toString();
    if (json['reviews'] != null) {
      _reviews = <ReviewModel>[];
      json['reviews'].forEach((v) {
        reviews!.add(ReviewModel.fromJson(v));
      });
    }
    _statusUpdatedAt = json['status_updated_at'].toString();
    _osPlatform = json['os_platform'].toString();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'formatted_id': formattedId,
        'guest': guest.toJson(),
        'host': host.toJson(),
        'listing': listing.toJson(),
        'images': images.map((e) => e.toJson()).toList(),
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

  getTotalNights() {
    return Constants.totalDays(calenderCheckout()) -
        Constants.totalDays(calenderCheckin());
  }

  String getArrivingTime() {
    String message = "";
    DateTime currentCalendar = DateTime.now();
    DateTime chekinCalender = calenderCheckin();
    DateTime checkoutCalender = DateTime(calenderCheckout().year,
        calenderCheckout().month, calenderCheckout().day, 14, 0);
    int dayDiff = Constants.totalDays(chekinCalender) -
        Constants.totalDays(currentCalendar);
    int checkoutDayDiff = Constants.totalDays(checkoutCalender) -
        Constants.totalDays(currentCalendar);

    if (dayDiff == 0) {
      message = "Check-in today";
    } else if (dayDiff == 1) {
      message = "Arriving tomorrow";
    } else if (dayDiff > 1) {
      message = "Arriving in $dayDiff  days";
    } else {
      //Checkin date passed, either stying or checked out
      if (checkoutDayDiff > -1) {
        message = "Currently staying";
      }

      if (checkoutDayDiff == 0) {
        message = "Check-out today";
      }

      if (checkoutDayDiff <= 0 &&
          currentCalendar.millisecond > checkoutCalender.millisecond) {
        if (isReviewButtonEnable()) {
          if (SharedPref.isHost) {
            //For Host
            message = "Awaiting guest review";
          } else {
            //For guest
            message = "Awaiting host review";
          }
        } else {
          message = "Past guest";
        }
      }
    }

    return message;
  }

  bool isReviewButtonEnable() {
    bool enableReviewButton = true;

    // return enableReviewButton;
    for (int i = 0; i < reviews.length; i++) {
      if (reviews[i].userId == SharedPref.userId) {
        enableReviewButton = false;
      }
    }

    return ((Constants.totalDays(calenderCheckout()) <=
                Constants.totalDays(DateTime.now())) &&
            (Constants.totalDays(calenderCheckout()) + 2 >=
                Constants.totalDays(DateTime.now()))) &&
        enableReviewButton;
  }
}
