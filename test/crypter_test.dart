import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:secure_messenger/utils/crypter/crypter_service.dart';

void main() {
  late CrypterService sut;

  setUp(() {
    final encrypter = Encrypter(AES(Key.fromLength(32)));
    sut = CrypterService(encrypter);
  });

  test("it encrypts plain text", () {
    const text = "My secret message";
    final base64 = RegExp(
        r'^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$');
    final encrypted = sut.encrypt(text);
    expect(base64.hasMatch(encrypted), true);
  });

  test("it decrypts the encrypted text", () {
    const text = "My secret message";
    final encrypted = sut.encrypt(text);
    final decrypted = sut.decrypt(encrypted);
    expect(decrypted, text);
  });
}
