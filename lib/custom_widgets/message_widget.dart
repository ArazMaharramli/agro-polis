import 'package:agropolis/models/message_model.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final MessageModel model;

  const MessageWidget({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3, bottom: 3, left: 10),
      child: Row(
        mainAxisAlignment:
            model.isReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            decoration: BoxDecoration(
              color: Colors.teal[200],
              borderRadius: !model.isReceived
                  ? BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5))
                  : BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5)),
            ),
            padding: EdgeInsets.all(7),
            child: Wrap(
              direction: Axis.horizontal,
              children: <Widget>[
                Text(
                  model.messageText,
                  softWrap: true,
                  //maxLines: 10,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
