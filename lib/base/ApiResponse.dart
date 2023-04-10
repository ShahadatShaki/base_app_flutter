import 'Serializable.dart';

class ApiResponse<T extends Serializable> {
  bool? status;
  String? message;
  bool? success;
  T? data;

  ApiResponse({this.status, this.success, this.message, this.data});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return ApiResponse<T>(
      status: json["status"],
      success: json["success"],
      message: json["message"],
      data: create(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": this.status,
        "success": this.success,
        "message": this.message,
        "data": this.data!.toJson(),
      };
}
