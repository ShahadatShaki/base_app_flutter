import 'package:base_app_flutter/base/Serializable.dart';
import 'package:base_app_flutter/model/BookingModel.dart';
import 'package:base_app_flutter/model/MessagesModel.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';

class ConversationModel implements Serializable {
  String? _id;
  String? _status;
  String? _createdAt;
  MessagesModel? _lastMessage;
  UserProfileModel? _host;
  UserProfileModel? _guest;
  BookingModel? _booking;
  bool? _bookingReviews;

  ConversationModel();

  String get id {
    _id ??= "";
    return _id!;
  }

  String get status {
    _status ??= "";
    return _status!;
  }

  String get createdAt {
    _createdAt ??= "";
    return _createdAt!;
  }

  MessagesModel get lastMessage {
    _lastMessage ??= MessagesModel();
    return _lastMessage!;
  }

  UserProfileModel get host {
    _host ??= UserProfileModel();
    return _host!;
  }

  UserProfileModel get guest {
    _guest ??= UserProfileModel();
    return _guest!;
  }

  BookingModel get booking {
    _booking ??= BookingModel();
    return _booking!;
  }

  set booking(booking){
    _booking = booking;
  }

  bool get bookingReviews {
    _bookingReviews ??= false;
    return _bookingReviews!;
  }

  ConversationModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _status = json['status'].toString();
    _createdAt = json['created_at'].toString();
    _lastMessage = json['last_message'] != null
        ? MessagesModel.fromJson(json['last_message'])
        : MessagesModel();
    _host = json['host'] != null
        ? UserProfileModel.fromJson(json['host'])
        : UserProfileModel();
    _guest = json['guest'] != null
        ? UserProfileModel.fromJson(json['guest'])
        : UserProfileModel();
    _booking = json['booking'] != null
        ? BookingModel.fromJson(json['booking'])
        : BookingModel();
    _bookingReviews = json['booking.reviews'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['status'] = status;
    data['created_at'] = createdAt;
    if (lastMessage != null) {
      data['last_message'] = lastMessage!.toJson();
    }
    if (host != null) {
      data['host'] = host!.toJson();
    }
    if (guest != null) {
      data['guest'] = guest!.toJson();
    }
    if (booking != null) {
      data['booking'] = booking!.toJson();
    }
    data['booking.reviews'] = bookingReviews;
    return data;
  }
}
