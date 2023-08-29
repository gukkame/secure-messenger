import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:secure_messenger/api/media_api.dart';
import 'package:secure_messenger/api/user_api.dart';
import 'package:secure_messenger/utils/basic_user_info.dart';
import 'package:secure_messenger/utils/media_type.dart';
import 'api.dart';

import '../utils/convert.dart';
import '../utils/user.dart';

class ContactsApi extends Api {
  Future<List<BasicUserInfo>> getContacts(String input, User user) async {
    try {
      List<BasicUserInfo> contacts = [];

      var data = (await read("users")).docs;

      for (var doc in data) {
        var foundUser = doc.data() as Map<String, dynamic>;
        if (foundUser["email"] != user.email &&
            (foundUser["name"] == input || foundUser["email"] == input)) {
          contacts.add(BasicUserInfo(
              email: foundUser["email"], name: foundUser["name"]));
        }
      }

      return contacts;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<List<BasicUserInfo>> getFriends(User user) async {
    try {
      List<BasicUserInfo> friends = [];

      var data = (await readPath(collection: "friends", path: user.email))
          .data() as Map<String, dynamic>?;
      if (data == null) return [];

      for (var entry in data["friends"].entries) {
        var userData = await UserApi().getUserInfo(email: entry.key);
        if (userData == null) {
          debugPrint("Couldn't find user info for ${entry.key}");
          continue;
        }

        //* Add getting the last message sent
        friends.add(
          BasicUserInfo(
            email: Convert.decrypt(entry.key),
            name: entry.value,
            image: await MediaApi().fetchFile(
              path: userData["image"],
              type: MediaType.image,
              onUpdate: (_, [__]) {},
              onComplete: (_) {},
              onError: (_) {},
            ),
          ),
        );
      }

      return friends;
    } catch (e) {
      debugPrint("$e");
      return [];
    }
  }

  Future<String?> addFriend(User user, String email, String name) async {
    try {
      await update(
        collection: "friends",
        path: email,
        data: {"friends.${Convert.encrypt(user.email)}": user.name},
      );
      await update(
          collection: "friends",
          path: user.email,
          data: {"friends.${Convert.encrypt(email)}": name});
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return "Internal server error.\nPlease contact support.";
    }
  }

  Future<String?> removeFriend(User user, String email) async {
    try {
      await update(
        collection: "friends",
        path: user.email,
        data: {"friends.${Convert.encrypt(email)}": FieldValue.delete()},
      );
      await update(
        collection: "friends",
        path: email,
        data: {"friends.${Convert.encrypt(user.email)}": FieldValue.delete()},
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
