import 'package:pointycastle/export.dart';
import 'package:pointycastle/src/platform_check/platform_check.dart';

SecureRandom generateSecureRandom() {
  final secureRandom = SecureRandom('Fortuna')
    ..seed(
        KeyParameter(Platform.instance.platformEntropySource().getBytes(32)));
  return secureRandom;
}