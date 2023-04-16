import 'Serializable.dart';

class ApiResponseList<T extends Serializable> {
  bool? _status;
  bool? _success;
  String? _message;
  List<T>? _data;

  bool get status {
    _status ??= false;
    return _status!;
  }

  bool get success {
    _success ??= false;
    return _success!;
  }

  String get message {
    _message ??= "";
    return _message!;
  }

  List<T> get data {
    _data ??= [];
    return _data!;
  }

  ApiResponseList.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    List<T>? data = [];
    json['data'].forEach((v) {
      data.add(create(v));
    });

    _status = json["status"];
    _success = json["success"];
    _message = json["message"];
    _data = data;
  }

  Map<String, dynamic> toJson() => {
        "status": this.status,
        "success": this.success,
        "message": this.message,
        // "data": this.data!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
