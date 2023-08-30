import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:secure_messenger/api/media_api.dart';
import 'package:secure_messenger/api/user_api.dart';
import 'package:secure_messenger/utils/basic_user_info.dart';
import 'package:secure_messenger/utils/colors.dart';
import 'package:secure_messenger/utils/media_type.dart';
import 'package:secure_messenger/utils/message.dart';
import 'package:secure_messenger/utils/user.dart';
import '../api/message_api.dart';
import '../components/chat_input_field.dart';
import '../utils/navigation.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late User user;
  late BasicUserInfo recipient;
  late bool isPrivate;
  final MessageApi _msgApi = MessageApi();
  String? _recipientImageUrl;
  String _chatId = "";
  bool _isTyping = false;
  bool _loading = true;
  List<Message> _messages = [];

  @override
  void didChangeDependencies() {
    recipient = Arguments.from(context).arg?[0];
    isPrivate = Arguments.from(context).arg?[1];
    _getRecipientImageUrl();
    _initMessages();
    super.didChangeDependencies();
  }

  void _getRecipientImageUrl() async {
    var recipientUserInfo = await UserApi().getUserInfo(email: recipient.email);
    if (recipientUserInfo == null) {
      throw Exception("chat: Couldn't load recipients user data");
    }
    _recipientImageUrl =
        await MediaApi().getProfilePictureLink(recipientUserInfo["image"]);
    setState(() {});
  }

  void _initMessages() async {
    await _getMessages();
    _setListener();
    setState(() {
      _loading = false;
    });
  }

  Future<void> _getMessages() async {
    List<Message> newMessages = [];

    debugPrint("getting messages");

    // Getting chat log or creating a new
    _chatId = _msgApi.createDocId(recipient.email, user.email, isPrivate);
    var resp = await _msgApi.getMessages(_chatId);
    debugPrint("check 1 done: $resp");
    if (resp == null) {
      _chatId = _msgApi.createDocId(user.email, recipient.email, isPrivate);
      resp = await _msgApi.getMessages(_chatId);
      debugPrint("check 2 done: $resp");

      if (resp == null) {
        await _msgApi.createNewChatRoom(_chatId, user.email, recipient.email);
        debugPrint("new chat room created");
      }
    }

    if (resp != null) {
      for (var msg in resp) {
        newMessages.add(Message(
          date: msg["date"],
          type: MediaTypeUtils.from(msg["type"]),
          body: msg["body"],
          seen: msg["seen"],
          sender: msg["sender"],
          setState: setState,
        ));
      }
    }

    _messages = newMessages;
  }

  void _setListener() async {
    _msgApi.getStream(collection: "chats", path: _chatId).listen((event) {
      if (event.exists) {
        var data = event.data() as Map<String, dynamic>?;
        if (data != null) {
          var messages = data["messages"] as List<dynamic>;
          var isRecipientTyping = data["${recipient.email}_typing"] as bool;

          if (messages.length > _messages.length) {
            // add new messages to the here
          }
          _isTyping = isRecipientTyping;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace:
            SafeArea(child: _appBarContainer(recipient.name, _isTyping)),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _messages.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) {
                          return _message(index, recipient.email);
                        },
                      ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ChatInputField(privateChat: isPrivate),
          ),
        ],
      ),
    );
  }

  Widget _message(index, email) {
    return GestureDetector(
      onDoubleTap: () => _messages[index].sender != email
          ? _editDeleteMessage(context, index)
          : '',
      child: Container(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
        child: Align(
          alignment: (_messages[index].sender == email
              ? Alignment.topLeft
              : Alignment.topRight),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (_messages[index].sender == email
                  ? Colors.grey.shade200
                  : Colors.blue[200]),
            ),
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: _messages[index].sender == email
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  _messages[index].body,
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
                setState(() => _messages[index].body = "Deleted");
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                setState(
                    () => _messages[index].body = textFieldController.text);
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
            '${_messages[index].date.toDate().hour.toString()}:${_messages[index].date.toDate().minute.toString()}',
            style: const TextStyle(color: Colors.black45, fontSize: 13),
          ),
          _messages[index].seen && _messages[index].sender != email
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
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 12),
            child: _recipientImageUrl == null
                ? Container(color: primeColor)
                : CircleAvatar(
                    backgroundImage: NetworkImage(_recipientImageUrl as String),
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
}
