import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_messenger/utils/media_type.dart';

class Message {
  final String sender;
  final Timestamp date;
  final MediaType type;
  final dynamic body;
  final bool seen;

  Message({
    required this.date,
    required this.type,
    required this.body,
    required this.seen,
    required this.sender,
  });
}
