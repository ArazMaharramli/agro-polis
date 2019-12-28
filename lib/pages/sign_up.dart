// import 'package:agropolis/pages/add_or_edit_user_details.dart';
// import 'package:agropolis/pages/home_page.dart';
// import 'package:agropolis/routers/user_init.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class SignUpPage extends StatefulWidget {
//   SignUpPage({Key key}) : super(key: key);

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   String phoneNo;
//   String smsCode;
//   String verificationId;
//   int _forceResendingCode;
//   final _scaffoldStateKey = new GlobalKey<ScaffoldState>();
//   @override
//   void initState() {
//     super.initState();
//     UserInit userInit = new UserInit();
//     userInit.isRegistered().then((uid) {
//       if (uid != null && uid.isNotEmpty) {
//         print("user is registered : $uid");
//         Navigator.of(context)
//             .pushReplacement(new MaterialPageRoute(builder: (context) {
//           return HomePage(uid: uid);
//         }));
//       }
//     });
//   }

//   Future<void> verifyNumber({int forceResendingToken = null}) async {
//     final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
//       this.verificationId = verID;
//       print("autoRetrieve");

//       ///Dialog here
//       // smsCodeDialog(context);
//     };

//     final PhoneVerificationCompleted verificationSuccess =
//         (AuthCredential credential) {
//       print("Verified");
//       signIn(credential: credential);
//       // Navigator.pushReplacement(context,
//       //     MaterialPageRoute(builder: (BuildContext context) => SignInPage()));
//     };

//     final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
//       this.verificationId = verID;
//       this._forceResendingCode = forceCodeResend;
//       print("smsCodeSent");
//       // signIn();
//       //smsCodeDialog(context);
//     };

//     final PhoneVerificationFailed verificationFailed =
//         (AuthException exception) {
//       print('$exception.message');

//       _scaffoldStateKey.currentState.showSnackBar(
//         SnackBar(
//           content: Container(
//             constraints: BoxConstraints(
//               minHeight: 100,
//             ),
//             child: Text(
//               "Xəta baş verdi",
//               softWrap: true,
//               style: TextStyle(color: Colors.red),
//             ),
//           ),
//           duration: Duration(seconds: 4),
//         ),
//       );
//     };
//     if (forceResendingToken != null) {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//           phoneNumber: "+994${this.phoneNo}",
//           codeAutoRetrievalTimeout: autoRetrieve,
//           codeSent: smsCodeSent,
//           timeout: const Duration(seconds: 30),
//           verificationCompleted: verificationSuccess,
//           verificationFailed: verificationFailed,
//           forceResendingToken: forceResendingToken);
//     } else {
//       await FirebaseAuth.instance.verifyPhoneNumber(
//           phoneNumber: "+994${this.phoneNo}",
//           codeAutoRetrievalTimeout: autoRetrieve,
//           codeSent: smsCodeSent,
//           timeout: const Duration(seconds: 30),
//           verificationCompleted: verificationSuccess,
//           verificationFailed: verificationFailed);
//     }
//   }

//   Future<bool> smsCodeDialog(BuildContext context) {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) => AlertDialog(
//               title: Text("SMS kodu daxil edin"),
//               content: TextField(
//                   keyboardType: TextInputType.number,
//                   textAlign: TextAlign.center,
//                   maxLength: 6,
//                   style: TextStyle(
//                     fontSize: 30,
//                   ),
//                   decoration: InputDecoration(hintText: "- - - - - -"),
//                   onChanged: (value) {
//                     this.smsCode = value;
//                   }),
//               actions: <Widget>[
//                 FlatButton(
//                     child: Text("Yenidən göndər"),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                       verifyNumber(
//                           forceResendingToken: this._forceResendingCode);
//                     }),
//                 RaisedButton(
//                   color: Colors.teal,
//                   child: Text(
//                     "Tamam",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     signIn();
//                     // FirebaseAuth.instance.currentUser().then((user) {
//                     //   if (user != null) {
//                     //     Navigator.pop(context);
//                     //     Navigator.pushReplacement(
//                     //         context,
//                     //         MaterialPageRoute(
//                     //             builder: (BuildContext context) =>
//                     //                 SignInPage()));
//                     //   } else {
//                     //    // Navigator.pop(context);
//                     //     signIn();
//                     //   }
//                     // });
//                   },
//                 ),
//               ],
//             ));
//   }

//   signIn({AuthCredential credential}) async {
//     if (credential == null) {
//       credential = PhoneAuthProvider.getCredential(
//         verificationId: verificationId,
//         smsCode: smsCode,
//       );
//     }
//     // final AuthCredential credential = PhoneAuthProvider.getCredential(
//     //   verificationId: verificationId,
//     //   smsCode: smsCode,
//     // );
//     await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
//       var storage = new FlutterSecureStorage();
//       storage.write(key: "user_uid", value: user.user.uid).then((onValue) {
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//             builder: (BuildContext context) => AddOrEditUserDetails(
//                 uid: user.user.uid, phoneNumber: user.user.phoneNumber)));
//       });
//     }).catchError((e) => print(e));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldStateKey,
//       extendBody: true,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.all(24.0),
//               child: ListView(
//                 shrinkWrap: true,
//                 children: <Widget>[
//                   TextField(
//                     autofocus: true,
//                     decoration: InputDecoration(
//                       hintText: "00 000 0000",
//                       prefix: Text(
//                         "+994",
//                         style: TextStyle(color: Colors.black),
//                       ),
//                       contentPadding:
//                           EdgeInsets.fromLTRB(20.00, 10.00, 20.00, 10.00),
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.phone,
//                     onChanged: (value) {
//                       this.phoneNo = value;
//                       print("phone number is: " + value);
//                     },
//                   ),
//                   RaisedButton(
//                     color: Colors.teal,
//                     onPressed:(){
//                       verifyNumber();
//                     } ,
//                     child: Text(
//                       "Təstiqlə",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scaffoldStateKey.currentState.dispose();
//     super.dispose();
//   }
// }
// import 'package:agrotaxi/main.dart';
// import 'package:agrotaxi/pages/add_or_edit_user_details.dart';
// import 'package:agrotaxi/routers/user_init.dart';
import 'package:agropolis/main.dart';
import 'package:agropolis/pages/add_or_edit_user_details.dart';
import 'package:agropolis/routers/user_init.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String phoneNo;
  String smsCode;
  String verificationId;
  int _forceResendingCode;
  bool _isConfirmCodeDialogActive = false;
  final _scaffoldStateKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    UserInit userInit = new UserInit();
    userInit.isRegistered().then((uid) {
      if (uid != null && uid.isNotEmpty) {
        print("user is registered : $uid");

        setState(() {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
          // this.child = SupportPage(uid: uid,);
        });
      }
    });
  }

  Future<void> verifyNumber({int forceResendingToken = null}) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
      this.verificationId = verID;
      print("autoRetrieve");

      ///Dialog here
      // if (!_isConfirmCodeDialogActive) {
      //   smsCodeDialog(context);
      // }
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      print("Verified");
      // if (_isConfirmCodeDialogActive) {
      //   Navigator.of(context).pop();
      // }
      signIn(credential: credential);
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationId = verID;
      this._forceResendingCode = forceCodeResend;
      print("smsCodeSent");
      // signIn();
      // if (!_isConfirmCodeDialogActive) {
      //   smsCodeDialog(context);
      // }
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print('${exception.message}');
      if (_isConfirmCodeDialogActive) {
        smsCodeDialog(context);
      }
      _scaffoldStateKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Xəta baş verdi",
            //"verificationFailed => ${exception.message}",
            style: TextStyle(color: Colors.red),
          ),
          duration: Duration(seconds: 4),
        ),
      );
    };
    if (forceResendingToken != null) {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+994${this.phoneNo}",
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsCodeSent,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationSuccess,
          verificationFailed: verificationFailed,
          forceResendingToken: forceResendingToken);
    } else {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+994${this.phoneNo}",
          codeAutoRetrievalTimeout: autoRetrieve,
          codeSent: smsCodeSent,
          timeout: const Duration(seconds: 30),
          verificationCompleted: verificationSuccess,
          verificationFailed: verificationFailed);
    }
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    _isConfirmCodeDialogActive = true;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text("SMS kodu daxil edin"),
              content: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  decoration: InputDecoration(hintText: "- - - - - -"),
                  onChanged: (value) {
                    this.smsCode = value;
                  }),
              actions: <Widget>[
                FlatButton(
                    child: Text("Yenidən göndər"),
                    onPressed: () {
                      //Navigator.of(context).pop();
                      //_isConfirmCodeDialogActive = false;
                      // _scaffoldStateKey.currentState.showSnackBar(
                      //   SnackBar(
                      //     content: Text(
                      //       "mammmamamaskdsakdakdajskdjskldjaskjaskdajlkjlkajdklasjdaljdaslkdjakldjsakldj",
                      //       style: TextStyle(color: Colors.red),
                      //     ),
                      //     duration: Duration(seconds: 4),
                      //   ),
                      // );
                      verifyNumber(
                          forceResendingToken: this._forceResendingCode);
                    }),
                RaisedButton(
                  color: Colors.teal,
                  child: Text(
                    "Tamam",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _isConfirmCodeDialogActive = false;
                    signIn();
                    // FirebaseAuth.instance.currentUser().then((user) {
                    //   if (user != null) {
                    //     Navigator.pop(context);
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (BuildContext context) =>
                    //                 SignInPage()));
                    //   } else {
                    //    // Navigator.pop(context);
                    //     signIn();
                    //   }
                    // });
                  },
                ),
              ],
            ));
  }

  signIn({AuthCredential credential}) async {
    if (credential == null) {
      credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
    }
    // final AuthCredential credential = PhoneAuthProvider.getCredential(
    //   verificationId: verificationId,
    //   smsCode: smsCode,
    // );
    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      var storage = new FlutterSecureStorage();
      storage.write(key: "user_uid", value: user.user.uid).then((onValue) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => AddOrEditUserDetails(
                uid: user.user.uid, phoneNumber: user.user.phoneNumber)));
      });
    }).catchError((e) {
      print(e);
      _scaffoldStateKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Xəta baş verdi",
            // " signIn => ${e.toString()}",
            style: TextStyle(color: Colors.red),
          ),
          duration: Duration(seconds: 4),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      extendBody: true,
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // width: MediaQuery.of(context).size.width * 0.6,
                // height: MediaQuery.of(context).size.height * 0.3,
                padding: EdgeInsets.all(24.0),
                alignment: Alignment.center,
                // decoration: BoxDecoration(
                //     image: DecorationImage(
                //         image: AssetImage("assets/images/agrotaxi_logo.png"),
                //         fit: BoxFit.cover)),
                child: Image.asset("assets/images/agrotaxi_logo.png"),
              ),
              Container(
                // height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.all(24.0),
                alignment: Alignment.center,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "00 000 0000",
                        prefix: Text(
                          "+994",
                          style: TextStyle(color: Colors.black),
                        ),
                        contentPadding:
                            EdgeInsets.fromLTRB(20.00, 10.00, 20.00, 10.00),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        this.phoneNo = value;
                        print("phone number is: " + value);
                      },
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        smsCodeDialog(context);
                        verifyNumber();
                      },
                      child: Text(
                        "Təstiqlə",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaffoldStateKey.currentState.dispose();
    super.dispose();
  }
}
