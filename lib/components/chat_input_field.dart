import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'container.dart';

import 'package:image_picker/image_picker.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _textEditingController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? image;
  // FlutterSoundRecord? _recorder;
  Timer? _timer;
  late String _filePath;

  final FlutterSoundRecord _audioRecorder = FlutterSoundRecord();
  bool _isRecording = false;

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
        if (image != null)
          Positioned(
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
          ),
        Padding(
          padding: const EdgeInsets.all(28.0),
          child: RoundedGradientContainer(
            gradient:
                const LinearGradient(colors: [Colors.black, Colors.black]),
            borderSize: 2,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () {
                    _pickImage();
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: _isRecording
                          ? "Recording..."
                          : 'Enter your message here...',
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                GestureDetector(
                  onLongPressStart: (details) {
                    _start();
                  },
                  onLongPressEnd: (details) {
                    _stop();
                    // setState(() {
                    // });
                  },
                  child: Icon(_isRecording ? Icons.stop : Icons.mic),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void sendMessage() {
    setState(() {
      _textEditingController.text = "";
      image = null;
    });

    if (_textEditingController.text != "") {
      debugPrint("Message");
      debugPrint(_textEditingController.text);
      //! Save message in database and send to other user
    }
    if (image != null) {
      //! Save image in database
    }
  }

  void _pickImage() async {
    var newImage = await picker.pickImage(source: ImageSource.gallery);
    if (newImage != null) {
      debugPrint("New Image Picked: ${newImage.path}");
      setState(() => image = File(newImage.path));
    }
  }

  Future<void> _start() async {
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

  Future<void> _stop() async {
    try {
      debugPrint("stop recording");
      setState(() {
        _isRecording = false;
      });
      await _audioRecorder.stop();
      debugPrint(_audioRecorder.toString());
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
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
