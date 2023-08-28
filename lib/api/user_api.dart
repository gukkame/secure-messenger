import 'package:flutter/cupertino.dart';
import 'package:secure_messenger/provider/provider_manager.dart';
import '../utils/convert.dart';
import '../utils/user.dart';
import 'api.dart';

class UserApi extends Api {
  /// Initialize a user in the database
  Future<bool> registerNewUser(
      {required String email,
      required String name,
      required String password}) async {
    try {
      await write(
        collection: "users",
        path: email,
        data: {
          "email": email,
          "name": name,
          "online": true,
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
        path: Convert.encrypt(email),
        data: {},
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Retrieves the username of the person with the given email
  Future<String?> getUsername({required String email}) async {
    try {
      var resp = await readPath(collection: "users", path: email);
      return (resp.data() as Map<String, dynamic>)["name"] as String;
    } catch (e) {
      return null;
    }
  }

  /// Updates the database to let everyone know the user is now online
  Future<void> setOnlineState(BuildContext context,
      {required String key}) async {
    User user = ProviderManager().getUser(context);
    await update(
      collection: "users",
      path: user.email,
      data: {"key": key, "online": true},
    );
  }

  /// Updates the database to let everyone know the user is now offline
  Future<void> setOfflineState(BuildContext context) async {
    User user = ProviderManager().getUser(context);
    await update(
      collection: "users",
      path: user.email,
      data: {"online": false},
    );
  }
}
