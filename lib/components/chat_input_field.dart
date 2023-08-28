import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_messenger/utils/colors.dart';

import 'container.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: RoundedGradientContainer(
        gradient: const LinearGradient(colors: [Colors.black, Colors.black]),
        borderSize: 2,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo), // Icon for adding images or videos
              onPressed: () {
                // Handle adding images or videos here
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
    );
  }

  void sendMessage() {
    debugPrint("Message");
    debugPrint(_textEditingController.text);

    setState(() => _textEditingController.text = "");
    if (_textEditingController.text != "") {
      //! Save message in database and send to other user
    }
  }
}
