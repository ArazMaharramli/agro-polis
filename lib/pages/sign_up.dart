import 'package:agropolis/pages/sign_in.dart';
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

  Future<void> verifyNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verID) {
      this.verificationId = verID;

      ///Dialog here
      smsCodeDialog(context);
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) {
      print("Verified");
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (BuildContext context) => SignInPage()));
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationId = verID;
      // signIn();
      smsCodeDialog(context);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print('$exception.message');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 30),
        verificationCompleted: verificationSuccess,
        verificationFailed: verificationFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Enter SMS code"),
              content: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                this.smsCode = value;
              }),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.teal,
                  child: Text(
                    "Done",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
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
                )
              ],
            ));
  }

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      var storage = new FlutterSecureStorage();
      storage.write(key: "user_uid", value: user.user.uid).then((onValue) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return SignInPage();
        }));
      });
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Sign In to AgroPolis"),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Text("AgroPolis"),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(hintText: "Enter phone number"),
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                this.phoneNo = value;
              },
            ),
          ),
          RaisedButton(
            color: Colors.teal,
            onPressed: verifyNumber,
            child: Text(
              "Verify",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
