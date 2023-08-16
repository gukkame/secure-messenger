import 'package:encrypt/encrypt.dart';
import 'package:secure_messenger/utils/crypter/crypter.dart';

class CrypterService implements Crypter {
  final Encrypter _encrypter;
  final _iv = IV.fromLength(16);

  CrypterService(this._encrypter);

  @override
  String decrypt(String text) {
    final encrypted = Encrypted.fromBase64(text);
    return _encrypter.decrypt(encrypted, iv: _iv);
  }

  @override
  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: _iv).base64;
  }
}
