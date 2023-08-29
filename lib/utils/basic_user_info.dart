import 'package:secure_messenger/utils/message.dart';

class BasicUserInfo {
  final String _name;
  final String _email;
  final Message? _lastMessage;

  String get name => _name;
  String get email => _email;
  Message? get lastMessage => _lastMessage;

  const BasicUserInfo({
    required String email,
    required String name,
    Message? lastMessage,
  })  : _email = email,
        _name = name,
        _lastMessage = lastMessage;

  @override
  bool operator ==(Object other) {
    if (other is BasicUserInfo) {
      return other.email == email &&
          other.name == name &&
          other.lastMessage == lastMessage;
    }
    return super == other;
  }

  @override
  int get hashCode => _name.hashCode ^ _email.hashCode ^ _lastMessage.hashCode;
}
