import '../base/Serializable.dart';

class Cancellation implements Serializable {

  String? title;
  String? body;
  String? forHost;
  int? day;

  Cancellation({this.title, this.body, this.forHost, this.day});

  Cancellation.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    forHost = json['for_host'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['for_host'] = this.forHost;
    data['day'] = this.day;
    return data;
  }

}
