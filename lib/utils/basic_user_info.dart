import 'package:secure_messenger/utils/message.dart';

class BasicUserInfo {
  final String _name;
  final String _email;
  final String? _imageUrl;
  final Message? _lastMessage;

  String get name => _name;
  String get email => _email;
  String? get imageUrl => _imageUrl;
  Message? get lastMessage => _lastMessage;

  const BasicUserInfo({
    required String email,
    required String name,
    String? image,
    Message? lastMessage,
  })  : _email = email,
        _name = name,
        _imageUrl = image,
        _lastMessage = lastMessage;

  @override
  bool operator ==(Object other) {
    if (other is BasicUserInfo) {
      return other.email == email &&
          other.name == name &&
          other.lastMessage == lastMessage &&
          other.imageUrl == imageUrl;
    }
    return super == other;
  }

  @override
  int get hashCode =>
      _name.hashCode ^
      _email.hashCode ^
      _lastMessage.hashCode ^
      imageUrl.hashCode;
}
