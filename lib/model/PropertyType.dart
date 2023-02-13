import '../base/Serializable.dart';

class PropertyType implements Serializable {
  String? _id;
  String? _name;
  String? _description;

  PropertyType();

  String get id { _id ??= ""; return _id!;}
  String get name { _name ??= ""; return _name!;}
  String get description { _description ??= ""; return _description!;}

  PropertyType.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _name = json['name'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
