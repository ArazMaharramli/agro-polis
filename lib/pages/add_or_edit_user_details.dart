import 'package:agropolis/models/user_model.dart';
import 'package:agropolis/providers/firebase_providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AddOrEditUserDetails extends StatefulWidget {
  final String uid;
  final String phoneNumber;
  AddOrEditUserDetails({Key key, this.uid, this.phoneNumber}) : super(key: key);
  @override
  _AddOrEditUserDetailsState createState() => _AddOrEditUserDetailsState();
}

class _AddOrEditUserDetailsState extends State<AddOrEditUserDetails> {
  UserModel _userModel = new UserModel();
  final _formStateKey = new GlobalKey<FormState>();
  final _scaffoldStateKey = new GlobalKey<ScaffoldState>();

  final UserProvider _userProvider = new UserProvider();

  Future<void> getUserDetails() async {
    // if (widget.uid == null) {
    //   var storage = FlutterSecureStorage();
    //   widget.uid = await storage.read(key: "user_uid");
    // }
    var doc =
        await Firestore.instance.collection("users").document(widget.uid).get();
    if (!doc.exists) {
    } else {
      _userModel = new UserModel.fromJson(doc.data);
    }
    print(_userModel.toMap().toString());
    return;
  }

  @override
  void initState() {
    super.initState();
    // getUserDetails().then((onValue) {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      body: SafeArea(
        //padding: EdgeInsets.all(24.0),
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Form(
            key: _formStateKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: IconButton(
                      icon: Icon(Icons.photo_camera),
                      iconSize: 50.0,
                      color: Colors.black,
                      highlightColor: Colors.white,
                      onPressed: () {
                        _scaffoldStateKey.currentState.showSnackBar(
                          SnackBar(
                            content: Text(
                              "Bu özəllik növbəti versiyada aktiv olunacaqdır",
                              style: TextStyle(color: Colors.yellow),
                            ),
                            duration: Duration(seconds: 6),
                          ),
                        );
                      },
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.teal[300]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    initialValue: _userModel.fullname ?? "",
                    decoration: InputDecoration(
                      hintText: "Filankəs Filankəsli",
                      //prefixText: "+994",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.00, 10.00, 20.00, 10.00),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      print("User fullname is: " + value);
                    },
                    onSaved: (value) {
                      _userModel.fullname = value;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    initialValue: _userModel.city ?? "",
                    decoration: InputDecoration(
                      hintText: "Şəhər",
                      //prefixText: "+994",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.00, 10.00, 20.00, 10.00),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      print("user city is: " + value);
                    },
                    onSaved: (value) {
                      _userModel.city = value;
                    },
                  ),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Text("Tamam"),
                      color: Colors.teal,
                      onPressed: () {
                        _formStateKey.currentState.save();
                        _userModel.uid = widget.uid;
                        _userModel.phoneNumber = widget.phoneNumber;
                        _userProvider
                            .editUserDetails(_userModel)
                            .then((onValue) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                              return new MyHomePage(uid:widget.uid);
                            }),
                            ModalRoute.withName('/'),
                          );
                        });
                        //Navigator.of(context).popUntil(ModalRoute.withName('/'));
                        // Navigator.of(context).pushReplacement(
                        //   new MaterialPageRoute(builder: (context) {
                        //     return new MyHomePage();
                        //   }),
                        // );
                        // pushAndRemoveUntil(
                        //   MaterialPageRoute(builder: (context) {
                        //     return new MyHomePage();
                        //   }),
                        //   ModalRoute.withName('/'),
                        // );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _formStateKey.currentState.dispose();
    _scaffoldStateKey.currentState.dispose();
    super.dispose();
  }
}
