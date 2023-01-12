
import '../base/Serializable.dart';

class DataModel implements Serializable{
  String? title;
  String? message;
  int? itemId;
  String? itemType;
  bool? isNew;
  String? image;
  String? id;
  bool? read;
  String? createdAt;

  DataModel(
      {this.title,
      this.message,
      this.itemId,
      this.itemType,
      this.isNew,
      this.image,
      this.id,
      this.read,
      this.createdAt});

  DataModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    message = json['message'];
    itemId = json['item_id'];
    itemType = json['item_type'];
    isNew = json['new'];
    image = json['image'];
    id = json['id'];
    read = json['read'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['item_id'] = this.itemId;
    data['item_type'] = this.itemType;
    data['new'] = this.isNew;
    data['image'] = this.image;
    data['id'] = this.id;
    data['read'] = this.read;
    data['created_at'] = this.createdAt;
    return data;
  }
}
