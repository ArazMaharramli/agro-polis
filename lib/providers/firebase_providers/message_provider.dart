import 'package:agropolis/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageProvider {
  Future<bool> sendMessage(MessageModel _messageModel) async {
    try {
      Firestore.instance
          .collection("Messages")
          .document(_messageModel.sendBy.uid)
          .get()
          .then((doc) {
        Map<String, dynamic> newData = {
          "IsAccomplished": false,
          "MessageCount": 1,
          "Messages": []
        };
        if (doc.exists) {
          newData["MessageCount"] = doc.data["Messages"].length + 1;
          newData["Messages"] = FieldValue.arrayUnion([_messageModel.toMap()]);
          Firestore.instance
              .collection("Messages")
              .document(_messageModel.sendBy.uid)
              .updateData(newData).then((onValue){
                print(_messageModel.messageText+"  is written to firestore");
              });
        } else {
          newData["Messages"] = [_messageModel.toMap()];
          Firestore.instance
              .collection("Messages")
              .document(_messageModel.sendBy.uid)
              .setData(newData);
        }
      });

      return true;
    } catch (e) {
      print("MessageProvider sendMessage method error ${e.toString()}");
      return false;
    }
  }

  Future<List<MessageModel>> getMessages(String uid) async {
    var messagesDoc =
        await Firestore.instance.collection("Messages").document(uid).get();
      if(messagesDoc.exists && messagesDoc.data.isNotEmpty){
        List<MessageModel> messages = List.generate(messagesDoc.data["Messages"].length, (index){
          return new MessageModel.fromJson(messagesDoc.data["Messages"][index]);
        });
        return messages;
      }
      return [];
  }
}
