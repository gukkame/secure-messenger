import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/export.dart';

import 'chat_encrypter.dart';

class ChatEncrypterService extends ChatEncrypter {
  @override
  String encrypt({
    required String text,
    required RSAPublicKey publicKey,
    required RSAPrivateKey privateKey,
  }) {
    final senderEncryptedRSA =
        enc.Encrypter(enc.RSA(publicKey: publicKey, privateKey: privateKey));
    final encryptedMessage =
        senderEncryptedRSA.encryptBytes(text.codeUnits).base64;

    return encryptedMessage;
  }

  @override
  String decrypt({
    required String message,
    required RSAPublicKey publicKey,
    required RSAPrivateKey privateKey,
  }) {
    final recipientEncrypter = enc.Encrypter(
      enc.RSA(publicKey: publicKey, privateKey: privateKey),
    );
    final decryptedMessage =
        recipientEncrypter.decrypt(enc.Encrypted.fromBase64(message));

    return decryptedMessage;
  }
}
