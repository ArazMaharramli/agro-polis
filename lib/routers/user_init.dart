import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/services.dart';
class UserInit {
  

  Future<String> isRegistered() async {
    try {
      final storage = new FlutterSecureStorage();
    
          //  await storage.delete(key:"user_uid");
    
      String userUID = await storage.read(key: "user_uid");
      print("++++++++++++ ${userUID.toString()}");
   
          //  await storage.delete(key:"user_uid");
    
      return userUID;
    } on PlatformException catch (e) {
      print(e.toString());
      return null;
    }
  }
}
