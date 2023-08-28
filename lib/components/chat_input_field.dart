import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_messenger/utils/colors.dart';
import 'container.dart';

import 'package:image_picker/image_picker.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  TextEditingController _textEditingController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  File? image;

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
                    decoration: const InputDecoration(
                      hintText: 'Enter your message here...',
                      border: InputBorder.none,
                    ),
                    textInputAction: TextInputAction.newline,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {},
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
    debugPrint("Message");
    debugPrint(_textEditingController.text);

    setState(() {
      _textEditingController.text = "";
      image = null;
    });

    if (_textEditingController.text != "") {
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
}
