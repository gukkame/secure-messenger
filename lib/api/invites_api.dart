import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../utils/convert.dart';
import '../utils/user.dart';
import 'api.dart';

class InvitesApi extends Api {
  Future<String?> acceptInvite(User user, String email, String name) async {
    String ourEmail = Convert.encrypt(user.email);
    String theirEmail = Convert.encrypt(email);

    try {
      await update(
        collection: "friends",
        path: ourEmail,
        data: {
          "friends.$theirEmail": name,
          "inbound.$theirEmail": FieldValue.delete()
        },
      );

      await update(
        collection: "friends",
        path: theirEmail,
        data: {
          "friends.$ourEmail": user.name,
          "outbound.$ourEmail": FieldValue.delete()
        },
      );

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> declineInvite(User user, String email, String name) async {
    String ourEmail = Convert.encrypt(user.email);
    String theirEmail = Convert.encrypt(email);
    try {
      await update(
        collection: "friends",
        path: ourEmail,
        data: {"inbound.$theirEmail": FieldValue.delete()},
      );

      await update(
        collection: "friends",
        path: theirEmail,
        data: {"outbound.$ourEmail": FieldValue.delete()},
      );

      return null;
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
  }
}
