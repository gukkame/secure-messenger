import 'package:flutter/cupertino.dart';
import 'package:secure_messenger/components/search_result.dart';
import 'package:secure_messenger/provider/provider_manager.dart';

import '../utils/convert.dart';
import '../utils/user.dart';
import 'api.dart';

class SearchApi extends Api {
  /// Takes in the current user and the search input. Return
  /// null if the friend request was sent successfully an error message otherwise.
  Future<String?> sendFriendRequest(
      User user, String email, String name) async {
    try {
      await update(
        collection: "friends",
        path: Convert.encrypt(email),
        data: {"inbound.${Convert.encrypt(user.email)}": user.name},
      );
      await update(
          collection: "friends",
          path: Convert.encrypt(user.email),
          data: {"outbound.${Convert.encrypt(email)}": name});
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return "Internal server error.\nPlease contact support.";
    }
  }

  Future<List<SearchResult>?> getUser(BuildContext context,
      {required String input}) async {
    try {
      User user = ProviderManager().getUser(context);
      List<SearchResult> result = [];
      var resp = await read("users");

      for (var doc in resp.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (data["name"] == input || data["email"] == Convert.encrypt(input)) {
          if (Convert.encrypt(user.email) == data["email"] &&
              user.name == data["name"]) {
            continue;
          }
          result.add(SearchResult(email: data["email"], name: data["name"]));
        }
      }
      
      return result;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
