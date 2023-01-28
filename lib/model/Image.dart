import '../base/Serializable.dart';

class Image implements Serializable {

  int? id;
  String? url;
  dynamic priority;

  Image({this.id, this.url, this.priority});

  Image.fromJson(Map<String, dynamic> json) {
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
