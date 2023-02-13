import 'package:base_app_flutter/base/Serializable.dart';

class MessagesModel implements Serializable {
  String? _id;
  String? _conversationId;
  String? _senderId;
  String? _body;
  String? _type;
  String? _createdAt;
  String? _readAt;

  MessagesModel();

  String get id { _id ??= ""; return _id!;}
  String get conversationId { _conversationId ??= ""; return _conversationId!;}
  String get senderId { _senderId ??= ""; return _senderId!;}
  String get body { _body ??= ""; return _body!;}
  String get type { _type ??= ""; return _type!;}
  String get createdAt { _createdAt ??= ""; return _createdAt!;}
  String get readAt { _readAt ??= ""; return _readAt!;}


  MessagesModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
    _conversationId = json['conversation_id'].toString();
    _senderId = json['sender_id'].toString();
    _body = json['body'].toString();
    _type = json['type'].toString();
    _createdAt = json['created_at'].toString();
    _readAt = json['read_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['conversation_id'] = this.conversationId;
    data['sender_id'] = this.senderId;
    data['body'] = this.body;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['read_at'] = this.readAt;
    return data;
  }
}
