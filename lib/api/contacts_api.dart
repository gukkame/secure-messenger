import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:secure_messenger/utils/basic_user_info.dart';
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
        // Add getting the last message sent between these two people
        friends.add(BasicUserInfo(
            email: Convert.decrypt(entry.key), name: entry.value));
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
