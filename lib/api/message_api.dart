import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../api/api.dart';
import '../../utils/combine_and_hash.dart';
import '../../utils/convert.dart';
import '../../utils/media_type.dart';

class MessageApi extends Api {
  String createDocId(String email1, String email2, bool isPrivate) {
    return combineAndHashEmails(
        email1, email2, isPrivate ? "private" : "public");
  }

  Future<List<Map<String, dynamic>>?> getMessages(String docId) async {
    try {
      List<Map<String, dynamic>> messages = [];
      var resp = await readPath(collection: "chats", path: docId);
      debugPrint("getMessages: ${resp.data().toString()}");
      if (!resp.exists) return null;
      var data =
          (resp.data() as Map<String, dynamic>)["messages"] as List<dynamic>;

      for (var msg in data) {
        messages.add(msg as Map<String, dynamic>);
      }

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
    String docId,
    String email1,
    String email2, {
    required bool isPrivate,
  }) async {
    try {
      write(collection: "chats", path: docId, data: {
        "messages": [],
        if (!isPrivate) "${email1}_typing": false,
        if (!isPrivate) "${email2}_typing": false,
      });
    } catch (e) {
      debugPrint("MessageApi: $e");
    }
  }

  Future<void> sendMessage(
    String docId, {
    required String sender,
    required String body,
    required MediaType type,
    required Timestamp date,
  }) async {
    try {
      update(collection: "chats", path: docId, data: {
        "messages": FieldValue.arrayUnion([
          {
            "sender": Convert.encrypt(sender),
            "body": body,
            "type": type.str,
            "date": date,
            "seen": false,
          }
        ])
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> setTypingStatus(
      {required String chatId,
      required String email,
      required bool isTyping}) async {
    try {
      update(
        collection: "chats",
        path: chatId,
        data: {"${email}_typing": isTyping},
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeChatRoom(String chatId) async {
    try {
      await delete(collection: "chats", path: chatId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
