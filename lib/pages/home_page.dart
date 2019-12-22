import 'package:agropolis/custom_widgets/message_widget.dart';
import 'package:agropolis/custom_widgets/send_message_input_field.dart';
import 'package:agropolis/models/message_model.dart';
import 'package:agropolis/providers/firebase_providers/message_provider.dart';
import 'package:agropolis/providers/firebase_providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String uid;
  HomePage({Key key, this.uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MessageModel newMessage = new MessageModel();
  MessageProvider _messageProvider = new MessageProvider();
  List<MessageModel> _messages = new List<MessageModel>();

  final ScrollController _scrollController = new ScrollController();
  final TextEditingController _textEditingController =
      new TextEditingController();
  final FocusNode _keyboardFocusNode = new FocusNode();

  @override
  void initState() {
    super.initState();
    UserProvider _userProvider = new UserProvider();
    _userProvider.getUserDetails(widget.uid).then((userModel) {
      newMessage.sendBy = userModel;
      newMessage.sendBy.uid = widget.uid;
    });

    _getMessages().then((onValue) {
      setState(() {});
    });
  }

  Future<void> _getMessages() async {
    var msgs = await _messageProvider.getMessages(widget.uid);
    _messages = msgs.reversed.toList();
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal[50],
      ),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              reverse: true,
              controller: _scrollController,
              dragStartBehavior: DragStartBehavior.down,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                if (_messages == null || _messages.isEmpty) {
                  return Container();
                }
                return MessageWidget(model: _messages[index]);
              },
              // ),(
              //   future: (),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasData) {
              //       if (snapshot.data.length == 0) {
              //         return Text("Mesajınız yoxdur");
              //       }
              //       return ListView.builder(
              //         controller: _scrollController,
              //         dragStartBehavior: DragStartBehavior.down,
              //         itemCount: snapshot.data.length,
              //         itemBuilder: (context, i) {
              //           if (_scrollController.position.maxScrollExtent != null && i == snapshot.data.length) {
              //             _scrollController.animateTo(
              //                 _scrollController.position.maxScrollExtent,
              //                 duration: Duration(microseconds: 200),
              //                 curve: Curves.linear);
              //           }

              //           return MessageWidget(model: snapshot.data[i]);
              //         },
              //       );
              //     }
              //     return Container();
              //   },
            ),
          ),
          SendMessageInputField(
            textEditingController: _textEditingController,
            keyboardFocusNode: _keyboardFocusNode,
            onFieldValueChanged: (value) {
              this.newMessage.messageText = value;
            },
            onSendButtonPressed: () {
              newMessage.sendDate = Timestamp.now();
              newMessage.isReceived = false;
              _messageProvider.sendMessage(newMessage).then((onValue) {
                _getMessages().then((value) {
                  setState(() {});
                });
              });
              _textEditingController.clear();
              _keyboardFocusNode.unfocus();
            },
          ),
        ],
      ),
    );
  }
}
