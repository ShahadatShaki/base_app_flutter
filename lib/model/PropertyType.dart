import '../base/Serializable.dart';

class PropertyType implements Serializable {
  int? id;
  String? name;
  String? description;

  PropertyType({this.id, this.name, this.description});

  PropertyType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
