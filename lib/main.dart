import 'package:agropolis/pages/home_page.dart';
import 'package:agropolis/pages/sign_up.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroPolis',
      routes: {
        '/': (context) => SignUpPage(),
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
  String uid;
  MyHomePage({Key key, this.uid}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AgroPolis"),
        centerTitle: true,
      ),
      body: HomePage(uid: widget.uid,),
    );
  }
}
