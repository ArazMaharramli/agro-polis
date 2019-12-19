import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
class UserInit {
  

  Future<bool> isRegistered() async {
    try {
      final storage = new FlutterSecureStorage();
      String userUID = await storage.read(key: "user_uid");
     print("++++++++++++ ${userUID.toString()}");
      return (userUID == null || userUID.isEmpty) ? false : true;
    } on PlatformException catch (e) {
      print(e.toString());
      return false;
    }
  }
}
