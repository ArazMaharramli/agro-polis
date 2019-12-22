import 'package:agropolis/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  UserModel sendBy;
  UserModel readBy;
  String messageText;
  Timestamp sendDate;
  Timestamp readDate;
  bool isReceived;

  MessageModel(
      {this.messageText,
      this.readDate,
      this.sendBy,
      this.readBy,
      this.sendDate,
      this.isReceived});


  MessageModel.fromJson(json)
      : this.sendBy = new UserModel.fromJson(json["SendBy"]),
        this.readBy = new UserModel.fromJson(json["ReadBy"]),
        this.messageText = json["MessageText"],
        this.sendDate = json["SendDate"],
        this.isReceived = json["IsReceived"];


  Map<String, dynamic> toMap() {
    return {
      "SendBy": this.sendBy ==null? null :this.sendBy.toMap(),
      "ReadBy": this.readBy ==null? null :this.readBy.toMap(),
      "MessageText": this.messageText,
      "SendDate": this.sendDate??null,
      "ReadDate":this.readDate??null,
      "IsReceived": this.isReceived,
    };
  }
}
