import 'package:agropolis/pages/add_or_edit_user_details.dart';
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
  final _scaffoldStateKey = new GlobalKey<ScaffoldState>();

  Future<void> verifyNumber({int forceResendingToken = null}) async {
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
      this._forceResendingCode = forceCodeResend;
      // signIn();
      // smsCodeDialog(context);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {
      print('$exception.message');
      _scaffoldStateKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            "Xəta baş verdi",
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
                  onPressed: () => verifyNumber(
                      forceResendingToken: this._forceResendingCode),
                ),
                RaisedButton(
                  color: Colors.teal,
                  child: Text(
                    "Tamam",
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
                ),
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
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => AddOrEditUserDetails(
                uid: user.user.uid, phoneNumber: user.user.phoneNumber)));
      });
    }).catchError((e) => print(e));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldStateKey,
      extendBody: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(24.0),
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
                    color: Colors.teal,
                    onPressed: verifyNumber,
                    child: Text(
                      "Təstiqlə",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
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
