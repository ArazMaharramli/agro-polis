import 'package:agropolis/pages/home_page.dart';
import 'package:agropolis/pages/sign_up.dart';
import 'package:agropolis/routers/user_init.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroPolis',
      routes: {
        '/': (context) => MyHomePage(),
      },
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),

      // home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget child = Container();
  @override
  void initState() {
    super.initState();
    UserInit userInit = new UserInit();
    userInit.isRegistered().then((uid) {
      if ( uid != null && uid.isNotEmpty) {
        print("user is registered : $uid");
        setState(() {
          this.child = HomePage(uid: uid,);
        });
      } else {
        Navigator.of(context)
            .pushReplacement(new MaterialPageRoute(builder: (context) {
          return SignUpPage();
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AgroPolis"),
        centerTitle: true,
      ),
      body: child,
    );
  }
}
