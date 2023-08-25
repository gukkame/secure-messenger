import 'package:flutter/cupertino.dart';
import 'api.dart';

class UserApi extends Api {
  Future<bool> registerNewUser(
      {required String email,
      required String name,
      required String phone}) async {
    try {
      await write(
        collection: "users",
        path: email,
        data: {
          "email": email,
          "name": name,
          "phone": phone,
          "key": "",
        },
      );
      await write(
        collection: "friends",
        path: email,
        data: {"friends": {}, "outbound": {}, "inbound": {}},
      );
      await write(
        collection: "chats",
        path: email,
        data: {},
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<String?> getUsername({required String email}) async {
    try {
      var resp = await readPath(collection: "users", path: email);
      return (resp.data() as Map<String, dynamic>)["name"] as String;
    } catch (e) {
      return null;
    }
  }
}
