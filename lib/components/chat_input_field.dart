import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'package:secure_messenger/provider/provider_manager.dart';
import 'package:secure_messenger/api/message_api.dart';
import 'package:secure_messenger/utils/media_type.dart';
import '../api/media_api.dart';
import '../utils/user.dart';
import 'container.dart';

import 'package:image_picker/image_picker.dart';

class ChatInputField extends StatefulWidget {
  final bool loading;
  final bool privateChat;
  final String chatId;

  const ChatInputField({
    super.key,
    required this.loading,
    required this.privateChat,
    required this.chatId,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  late User user;
  final MessageApi _messageApi = MessageApi();
  final MediaApi _mediaApi = MediaApi();
  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? image;
  File? video;
  Timer? _timer;
  late String _filePath;

  final FlutterSoundRecord _audioRecorder = FlutterSoundRecord();
  bool _isRecording = false;

  @override
  void initState() {
    user = ProviderManager().getUser(context);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (image != null) _displayPickedImage,
        Padding(
          padding: const EdgeInsets.fromLTRB(27, 5, 27, 20),
          child: RoundedGradientContainer(
            gradient:
                const LinearGradient(colors: [Colors.black, Colors.black]),
            borderSize: 2,
            child: Row(
              children: <Widget>[
                widget.privateChat
                    ? const SizedBox(
                        width: 20,
                      )
                    : _popupMenu,
                _textInputField,
                widget.privateChat ? const SizedBox.shrink() : _recordButton,
                _sendMessageButton,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _sendMessageButton {
    return IconButton(
      icon: const Icon(Icons.send),
      onPressed: widget.loading
          ? null
          : widget.loading
              ? null
              : () {
                  sendMessage();
                },
    );
  }

  Widget get _recordButton {
    return GestureDetector(
      onLongPressStart: widget.loading
          ? null
          : (details) {
              _startRecording();
            },
      onLongPressEnd: widget.loading
          ? null
          : (details) {
              _stopRecording();
            },
      child: Icon(_isRecording ? Icons.stop : Icons.mic),
    );
  }

  Widget get _textInputField {
    return Expanded(
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: _isRecording
              ? "Recording..."
              : video != null
                  ? 'Video uploaded!'
                  : 'Enter your message here...',
          border: InputBorder.none,
        ),
        textInputAction: TextInputAction.newline,
      ),
    );
  }

  Widget get _displayPickedImage {
    return Positioned(
      top: 100,
      right: 16,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: FileImage(image!),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget get _popupMenu {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          onTap: () => _pickImage(),
          child: const Text('Photo'),
        ),
        PopupMenuItem(
          onTap: () => _pickVideo(),
          child: const Text('Video'),
        ),
      ],
    );
  }

  void sendMessage() {
    if (_textEditingController.text != "") {
      debugPrint("Message");
      debugPrint(_textEditingController.text);
      _messageApi.sendMessage(
        widget.chatId,
        sender: user.email,
        body: _textEditingController.text,
        type: MediaType.text,
        date: Timestamp.now(),
      );
    }
    checkMedia(image);
    checkMedia(video);

    setState(() {
      _textEditingController.text = "";
      image = null;
      video = null;
    });
  }

  void checkMedia(media) {
    if (media != null) {
      var type = MediaType.image;
      if (media == 'video') {
        type = MediaType.video;
      }
      String link =
          _mediaApi.toPath(user.email, file: media as File, type: type);
      _mediaApi.uploadFile(
        link,
        file: media as File,
        type: type,
        onComplete: ({required String fileLink, required String msg}) {
          debugPrint("$media uploaded! $msg");
          _messageApi.sendMessage(
            widget.chatId,
            sender: user.email,
            body: fileLink,
            type: type,
            date: Timestamp.now(),
          );
        },
        onUpdate: (msg, [progress]) => debugPrint(progress.toString()),
        onError: (msg) {
          throw Exception("$media UPLOAD ERROR: $msg");
        },
      );
    }
  }

  void _pickImage() async {
    var newImage = await picker.pickImage(source: ImageSource.gallery);

    if (newImage != null) {
      debugPrint("New Image Picked: ${newImage.path}");
      setState(() => image = File(newImage.path));
    }
  }

  void _pickVideo() async {
    var newVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (newVideo != null) {
      debugPrint("New Video Picked: ${newVideo.path}");
      setState(() => video = File(newVideo.path));
    }
  }

  Future<void> _startRecording() async {
    debugPrint("start");
    try {
      if (await _audioRecorder.hasPermission()) {
        debugPrint("permission granted");

        setState(() => _isRecording = true);

        final directory = await getTemporaryDirectory();
        _filePath = '${directory.path}/audio.mp3';
        await _audioRecorder.start(path: _filePath);
      } else {
        debugPrint("no permission");
        await _requestPermissions();
        setState(() => _isRecording = false);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      debugPrint("stop recording");
      uploadAudio();
      setState(() {
        _filePath = '';
        _isRecording = false;
      });
      await _audioRecorder.stop();
      
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  void uploadAudio() {
    if (_filePath != "") {
      String link = _mediaApi.toPath(user.email,
          file: File(_filePath), type: MediaType.audio);
      _mediaApi.uploadFile(
        link,
        file: File(_filePath),
        type: MediaType.audio,
        onComplete: ({required String fileLink, required String msg}) {
          debugPrint("Audio uploaded! $msg");
          _messageApi.sendMessage(
            widget.chatId,
            sender: user.email,
            body: fileLink,
            type: MediaType.audio,
            date: Timestamp.now(),
          );
        },
        onUpdate: (msg, [progress]) => debugPrint(progress.toString()),
        onError: (msg) {
          throw Exception("Audio UPLOAD ERROR: $msg");
        },
      );
    }
  }

  Future<bool> _requestPermissions() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
