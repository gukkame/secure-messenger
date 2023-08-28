import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import '../utils/convert.dart';
import '../utils/media_type.dart';

class MediaApi {
  Reference get _storage => FirebaseStorage.instance.ref();

  void uploadFile(String email,
      {required File file,
      required MediaType type,
      required void Function(String msg, [int? progress]) onUpdate,
      required void Function(String msg) onComplete,
      required void Function(String msg) onError}) {
    var task = _storage
        .child("${type.str}s/${Convert.encrypt(email)}")
        .putFile(File(file.path))
        .snapshotEvents;
    _handleUploadProgress(
      task,
      type.str,
      onUpdate: onUpdate,
      onComplete: onComplete,
      onError: onError,
    );
  }

  Future<dynamic> fetchFile(
      {required String fileName,
      required MediaType type,
      required void Function(String msg, [int? progress]) onUpdate,
      required void Function(String msg) onComplete,
      required void Function(String msg) onError}) async {
    Uint8List? data = await _storage.child("${type.str}s/$fileName").getData();
    if (data == null) {
      onError("${type.str} has no data");
      return null;
    }
    switch (type) {
      case MediaType.image:
        return Image.memory(data);
      case MediaType.video:
        return throw UnimplementedError("video fetching not implemented");
      case MediaType.audio:
        return throw UnimplementedError("audio fetching not implemented");
    }
  }

  void _handleUploadProgress(Stream<TaskSnapshot> stream, String type,
      {required void Function(String msg, [int? progress]) onUpdate,
      required void Function(String msg) onComplete,
      required void Function(String msg) onError}) {
    try {
      stream.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            int progress = (100.0 *
                    (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes))
                .round();
            onUpdate("Uploading $type: $progress%", progress);
            break;
          case TaskState.paused:
            onUpdate("Uploading $type has been paused");
            break;
          case TaskState.success:
            onComplete("$type uploaded successfully.");
            break;
          case TaskState.canceled:
            onUpdate(
                "Uploading $type has been canceled. Please contact support");
            break;
          case TaskState.error:
            onError(taskSnapshot.metadata.toString());
            break;
        }
      });
    } catch (e) {
      onError(e.toString());
    }
  }
}
