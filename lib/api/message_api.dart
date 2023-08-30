import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:secure_messenger/api/api.dart';
import 'package:secure_messenger/utils/combine_and_hash.dart';

class MessageApi extends Api {
  String createDocId(String email1, String email2, bool isPrivate) {
    return combineAndHashEmails(
        email1, email1, isPrivate ? "private" : "public");
  }

  Future<List<Map<String, dynamic>>?> getMessages(String docId) async {
    try {
      List<Map<String, dynamic>> messages = [];
      return messages;
    } on FirebaseException catch (e) {
      debugPrint(e.code);
      return null;
    } catch (e) {
      debugPrint("MessageApi: $e");
      return null;
    }
  }

  Future<void> createNewChatRoom(
      String docId, String email1, String email2) async {
    try {
      write(collection: "chats", path: docId, data: {
        "messages": {},
        "${email1}_typing": false,
        "${email2}_typing": false,
      });
    } catch (e) {
      debugPrint("MessageApi: $e");
    }
  }
}
