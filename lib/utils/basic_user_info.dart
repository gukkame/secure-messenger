import 'package:flutter/material.dart';
import 'package:secure_messenger/utils/message.dart';

class BasicUserInfo {
  final String _name;
  final String _email;
  final Image? _image;
  final Message? _lastMessage;

  String get name => _name;
  String get email => _email;
  Image get image => _image as Image;
  Message? get lastMessage => _lastMessage;

  const BasicUserInfo({
    required String email,
    required String name,
    Image? image,
    Message? lastMessage,
  })  : _email = email,
        _name = name,
        _image = image,
        _lastMessage = lastMessage;

  @override
  bool operator ==(Object other) {
    if (other is BasicUserInfo) {
      return other.email == email &&
          other.name == name &&
          other.lastMessage == lastMessage &&
          other.image == image;
    }
    return super == other;
  }

  @override
  int get hashCode =>
      _name.hashCode ^ _email.hashCode ^ _lastMessage.hashCode ^ image.hashCode;
}
