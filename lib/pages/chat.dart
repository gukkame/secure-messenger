import 'package:flutter/material.dart';
import '../components/chat_input_field.dart';
import '../utils/navigation.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  bool read;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.read});
}

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    var arg = Arguments.from(context).arg?[0];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(child: _appBarContainer(arg)),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _message(index);
            },
          ),
          const Align(
              alignment: Alignment.bottomCenter, child: ChatInputField()),
        ],
      ),
    );
  }

  Widget _message(index) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (messages[index].messageType == "receiver"
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (messages[index].messageType == "receiver"
                ? Colors.grey.shade200
                : Colors.blue[200]),
          ),
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: messages[index].messageType == "receiver"
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                messages[index].messageContent,
                style: const TextStyle(fontSize: 15),
              ),
              _messageInfo(index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _messageInfo(index) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            "11:22(Send time)  ",
            style: TextStyle(color: Colors.black45, fontSize: 13),
          ),
          messages[index].read && messages[index].messageType == "sender"
              ? const Icon(
                  Icons.done_all,
                  size: 16,
                  color: Colors.blue,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _appBarContainer(arg) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 2, right: 12),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "<https://randomuser.me/api/portraits/men/5.jpg>"),
              maxRadius: 20,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  arg.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ChatMessage> messages = [
    //! Get data from DataBase
    ChatMessage(
        messageContent: "Hello, Will", messageType: "receiver", read: true),
    ChatMessage(
        messageContent: "How have you been?",
        messageType: "receiver",
        read: true),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender",
        read: true),
    ChatMessage(
        messageContent: "ehhhh, doing OK.",
        messageType: "receiver",
        read: true),
    ChatMessage(
        messageContent: "Is there any thing wrong?",
        messageType: "sender",
        read: false),
    ChatMessage(
        messageContent: "Hello, Will", messageType: "receiver", read: true),
    ChatMessage(
        messageContent: "How have you been?",
        messageType: "receiver",
        read: true),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender",
        read: true),
    ChatMessage(
        messageContent: "ehhhh, doing OK.",
        messageType: "receiver",
        read: true),
    ChatMessage(
        messageContent: "Is there any thing wrong?",
        messageType: "sender",
        read: false),
    ChatMessage(
        messageContent: "Hello, Will", messageType: "receiver", read: true),
    ChatMessage(
        messageContent: "How have you been?",
        messageType: "receiver",
        read: true),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender",
        read: true),
    ChatMessage(
        messageContent: "ehhhh, doing OK.",
        messageType: "receiver",
        read: true),
    ChatMessage(
        messageContent: "Is there any thing wrong?",
        messageType: "sender",
        read: false),
  ];
}
