import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_messenger/api/media_api.dart';
import 'package:secure_messenger/utils/media_type.dart';

class Message {
  final String sender;
  dynamic body;
  final MediaType type;
  final Timestamp date;
  final bool seen;
  final Function setState;
  bool _loading = false;

  bool get loading => _loading;

  void _fetchFile() async {
    body = await MediaApi().fetchFile(path: body, type: type);
    _loading = false;
    setState();
  }

  Message({
    required this.sender,
    required this.body,
    required this.type,
    required this.date,
    required this.seen,
    required this.setState,
  }) {
    if (type != MediaType.text) {
      _loading = true;
      _fetchFile();
    }
  }
}
