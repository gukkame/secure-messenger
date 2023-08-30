import 'package:cloud_firestore/cloud_firestore.dart';

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

  static Message fromMap(
      Map<String, dynamic> data, void Function(void Function() fn) setState) {
    return Message(
      sender: data["sender"],
      body: data["body"],
      type: data["type"],
      date: data["date"],
      seen: data["seen"],
      setState: setState,
    );
  }

  Message({
    required String sender,
    required this.body,
    required String type,
    required this.date,
    required this.seen,
    required this.setState,
  }) {
    this.sender = Convert.decrypt(sender);
    this.type = MediaTypeUtils.from(type);
    if (this.type != MediaType.text) {
      _loading = true;
      _fetchFile();
    }
  }
}
