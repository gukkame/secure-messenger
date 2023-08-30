import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secure_messenger/utils/media_type.dart';
import 'package:secure_messenger/utils/message.dart';
import '../components/chat_input_field.dart';
import '../utils/navigation.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final bool _isTyping = true;

  @override
  Widget build(BuildContext context) {
    String name = Arguments.from(context).arg?[0].name;
    String email = Arguments.from(context).arg?[0].email;
    bool privateChat = Arguments.from(context).arg?[1];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(child: _appBarContainer(name, _isTyping)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _message(index, email);
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatInputField(privateChat: privateChat),
          ),
        ],
      ),
    );
  }

  Widget _message(index, email) {
    return GestureDetector(
      onDoubleTap: () => messages[index].sender != email
          ? _editDeleteMessage(context, index)
          : '',
      child: Container(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
        child: Align(
          alignment: (messages[index].sender == email
              ? Alignment.topLeft
              : Alignment.topRight),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (messages[index].sender == email
                  ? Colors.grey.shade200
                  : Colors.blue[200]),
            ),
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: messages[index].sender == email
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  messages[index].body,
                  style: const TextStyle(fontSize: 15),
                ),
                _messageInfo(index, email),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _editDeleteMessage(context, index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController textFieldController = TextEditingController();

        return AlertDialog(
          title: const Text('Edit/Delete message'),
          content: TextField(
            controller: textFieldController,
            decoration: const InputDecoration(
              hintText: 'Enter your text',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() => messages[index].body = "Deleted");
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                setState(() => messages[index].body = textFieldController.text);
                Navigator.pop(context);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Widget _messageInfo(index, email) {
    return Padding(
      padding: const EdgeInsets.only(top: 3, bottom: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${messages[index].date.toDate().hour.toString()}:${messages[index].date.toDate().minute.toString()}',
            style: const TextStyle(color: Colors.black45, fontSize: 13),
          ),
          messages[index].seen && messages[index].sender != email
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

  Widget _appBarContainer(arg, isTyping) {
    return Container(
      padding: const EdgeInsets.only(right: 16),
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
                isTyping
                    ? const Text(
                        "Typing...",
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Message> messages = [
    //! Get data from DataBase
    //! If typing is true then add extra message at the end of List to call rebuild ListView and add Typing message
    Message(
        date: Timestamp.now(),
        type: MediaType.text,
        body: "Hello beautiful!",
        seen: true,
        sender: "cola@gmail.com"),
    Message(
        date: Timestamp.now(),
        type: MediaType.text,
        body: "Heyy!",
        seen: true,
        sender: "laura@gmail.com"),
    Message(
        date: Timestamp.now(),
        type: MediaType.text,
        body: "How are you?",
        seen: false,
        sender: "laura@gmail.com"),
  ];
}
