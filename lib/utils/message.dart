import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pointycastle/impl.dart';
import 'package:secure_messenger/chat_encrypter/chat_encrypter_service.dart';
import 'package:secure_messenger/utils/basic_user_info.dart';

import '../../api/media_api.dart';
import '../../utils/convert.dart';
import '../../utils/media_type.dart';

class Message {
  late String sender;
  dynamic body;
  late MediaType type;
  late Timestamp date;
  final bool seen;
  final void Function(void Function() fn) setState;
  bool _loading = false;

  bool get loading => _loading;

  void _fetchFile() async {
    body = await MediaApi().fetchFile(path: body, type: type);
    _loading = false;
    setState(() {});
  }

  void _decryptMessage(
      {required String publicKey, required RSAPrivateKey privateKey}) async {
    body = ChatEncrypterService().decrypt(
      message: body,
      publicKey:
          ChatEncrypterService().stringToRSAKey(publicKey, isPrivate: false),
      privateKey: privateKey,
    );
  }

  static Message fromMap(
      Map<String, dynamic> data,
      void Function(void Function() fn) setState,
      bool isPrivate,
      BasicUserInfo recipient,
      RSAPrivateKey? privateKey) {
    return Message(
      sender: data["sender"],
      body: data["body"],
      type: data["type"],
      date: data["date"],
      seen: data["seen"],
      setState: setState,
      isPrivate: isPrivate,
      publicKey: recipient.key,
      privateKey: privateKey,
    );
  }

  Message({
    required String sender,
    required this.body,
    required String type,
    required this.date,
    required this.seen,
    required this.setState,
    required bool isPrivate,
    String? publicKey,
    RSAPrivateKey? privateKey,
  }) {
    this.sender = Convert.decrypt(sender);
    this.type = MediaTypeUtils.from(type);
    if (this.type != MediaType.text) {
      if (isPrivate) {
        throw Exception(
            "MediaType other than text was sent to a private chat message");
      }
      _loading = true;
      _fetchFile();
    } else if (isPrivate) {
      _decryptMessage(
        publicKey: publicKey as String,
        privateKey: privateKey as RSAPrivateKey,
      );
    }
  }
}
