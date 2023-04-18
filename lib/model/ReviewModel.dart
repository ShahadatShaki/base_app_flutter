import 'package:base_app_flutter/model/ListingModel.dart';
import 'package:base_app_flutter/model/UserProfileModel.dart';

class ReviewModel {
  String? _id;
  String? _userId;
  int? _stars;
  StarsDetail? _starsDetail;
  String? _body;
  int? _bookingId;
  UserProfileModel? _creator;
  ListingModel? _listing;

  // List<Null>? _images;

  String get id {
    _id ??= "";
    return _id!;
  }

  int get stars {
    _stars ??= 0;
    return _stars!;
  }

  StarsDetail get starsDetail {
    _starsDetail ??= StarsDetail();
    return _starsDetail!;
  }

  String get body {
    _body ??= "";
    return _body!;
  }
  String get userId {
    _userId ??= "";
    return _userId!;
  }

  int get bookingId {
    _bookingId ??= 0;
    return _bookingId!;
  }

  UserProfileModel get creator {
    _creator ??= UserProfileModel();
    return _creator!;
  }

  ListingModel get listing {
    _listing ??= ListingModel();
    return _listing!;
  }

  ReviewModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _stars = json['stars'];
    _starsDetail = json['stars_detail'] != null
        ? StarsDetail.fromJson(json['stars_detail'])
        : null;
    _body = json['body'];
    _bookingId = json['booking_id'];
    _creator = json['creator'] != null
        ? UserProfileModel.fromJson(json['creator'])
        : null;
    _listing =
        json['listing'] != null ? ListingModel.fromJson(json['listing']) : null;
    // if (json['images'] != null) {
    //   _images = <Null>[];
    //   json['images'].forEach((v) {
    //     _images!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['stars'] = stars;
    data['stars_detail'] = starsDetail.toJson();
    data['body'] = body;
    data['booking_id'] = bookingId;
    data['user_id'] = userId;
    data['creator'] = creator.toJson();
    data['listing'] = listing.toJson();
    // if (this._images != null) {
    //   data['images'] = this._images!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class StarsDetail {
  String? _place;
  String? _cleanliness;
  String? _behaviour;

  StarsDetail();

  String get place {
    _place ??= "";
    return _place!;
  }

  String get cleanliness {
    _cleanliness ??= "";
    return _cleanliness!;
  }

  String get behaviour {
    _behaviour ??= "";
    return _behaviour!;
  }

  StarsDetail.fromJson(Map<String, dynamic> json) {
    _place = json['place'];
    _cleanliness = json['cleanliness'];
    _behaviour = json['behaviour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place'] = place;
    data['cleanliness'] = cleanliness;
    data['behaviour'] = behaviour;
    return data;
  }
}
