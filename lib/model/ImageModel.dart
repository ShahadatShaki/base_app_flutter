import '../base/Serializable.dart';

class ImageModel implements Serializable {
  int? id;
  String? url;
  dynamic priority;

  ImageModel({this.id, this.url, this.priority});

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['priority'] = this.priority;
    return data;
  }
}
