import '../base/Serializable.dart';

class NotificationModel implements Serializable {
  String? _title;
  String? _message;
  String? _body;
  String? _itemType;
  String? _itemId;
  String? _new;
  String? _readAt;
  String? _id;
  String? _createdAt;
  String? _image;


  String get title {
    _title ??= "";
    return _title!;
  }

  String get message {
    _message ??= "";
    return _message!;
  }

  String get body {
    _body ??= "";
    return _body!;
  }

  String get itemType {
    _itemType ??= "";
    return _itemType!;
  }

  String get itemId {
    _itemId ??= "";
    return _itemId!;
  }

  String get isNew {
    _new ??= "";
    return _new!;
  }

  String get readAt {
    _readAt ??= "";
    return _readAt!;
  }

  String get id {
    _id ??= "";
    return _id!;
  }

  String get createdAt {
    _createdAt ??= "";
    return _createdAt!;
  }

  String get image {
    _image ??= "";
    return _image!;
  }

  NotificationModel.fromJson(Map<String, dynamic> json) {
    _title = json['title'].toString();
    _message = json['message'].toString();
    _body = json['body'].toString();
    _itemType = json['item_type'].toString();
    _itemId = json['item_id'].toString();
    _new = json['new'].toString();
    _readAt = json['read_at'].toString();
    _id = json['id'].toString();
    _createdAt = json['created_at'].toString();
    _image = json['image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['message'] = this.message;
    data['body'] = this.body;
    data['item_type'] = this.itemType;
    data['item_id'] = this.itemId;
    data['new'] = this.isNew;
    data['read_at'] = this.readAt;
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['image'] = this.image;
    return data;
  }
}
