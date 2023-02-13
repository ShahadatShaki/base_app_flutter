import '../base/Serializable.dart';

class ImageModel implements Serializable {
  String? _id;
  String? _url;
  String? _priority;

  ImageModel();

  String get id {
    _id ??= "";
    return _id!;
  }

  String get url {
    _url ??= "";
    return _url!;
  }

  String get priority {
    _priority ??= "";
    return _priority!;
  }

  ImageModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _url = json['url'] != null ? json['url'].toString() : "";
    _priority = json['priority'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['priority'] = this.priority;
    return data;
  }
}
