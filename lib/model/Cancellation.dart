import '../base/Serializable.dart';

class Cancellation implements Serializable {

  String? _title;
  String? _body;
  String? _forHost;
  String? _day;

  Cancellation();

  String get title { _title ??= ""; return _title!;}
  String get body { _body ??= ""; return _body!;}
  String get forHost { _forHost ??= ""; return _forHost!;}
  String get day { _day ??= ""; return _day!;}

  Cancellation.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _body = json['body'];
    _forHost = json['for_host'];
    _day = json['day'].toString();
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
