import 'package:flutter/material.dart';

class SendMessageInputField extends StatelessWidget {
  final onSendButtonPressed;
  final onFieldValueChanged;
  final textEditingController;
  final keyboardFocusNode;
  const SendMessageInputField(
      {Key key,
      this.onSendButtonPressed,
      this.onFieldValueChanged,
      this.textEditingController,
      this.keyboardFocusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 70),
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: <Widget>[
                    // SizedBox(width: 8.0),
                    // Padding(
                    //   padding: EdgeInsets.only(right: 8.0, left: 8.0),
                    //   child: Icon(Icons.insert_emoticon,
                    //       size: 30.0, color: Theme.of(context).hintColor),
                    // ),as
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 18.0),
                        child: TextField(
                          controller: textEditingController,
                          focusNode: keyboardFocusNode,
                          minLines: 1,
                          maxLines: 6,
                          onChanged: this.onFieldValueChanged,
                          style: TextStyle(fontSize: 23),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 16.0),
                            hintText: 'Probleminizi bizə bildirin',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(right: 8.0),
                    //   child: Icon(Icons.attach_file,
                    //       size: 30.0, color: Theme.of(context).hintColor),
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(right: 8.0),
                    //   child: Icon(Icons.camera_alt,
                    //       size: 30.0, color: Theme.of(context).hintColor),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            padding: EdgeInsets.only(left: 8.0),
            onPressed: this.onSendButtonPressed,
            icon: Padding(
              padding: EdgeInsets.all(0.0),
              child: CircleAvatar(
                child: Icon(Icons.send),
              ),
            ),
          )
        ],
      ),
    );
  }
}
