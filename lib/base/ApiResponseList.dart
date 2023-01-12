import 'dart:convert';

import 'Serializable.dart';

class ApiResponseList<T extends Serializable> {
  bool? status;
  String? message;
  List<T>? data;

  ApiResponseList({this.status, this.message, this.data});

  factory ApiResponseList.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    List<T>? data = [];
    json['data'].forEach((v) {
      data.add(create(v));
    });

    return ApiResponseList<T>(
      status: json["status"],
      message: json["message"],
      data: data,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": this.status,
        "message": this.message,
        // "data": this.data!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
