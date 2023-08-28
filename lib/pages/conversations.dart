import 'package:flutter/material.dart';
import 'package:secure_messenger/utils/colors.dart';

import '../components/app_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../components/conversation_list.dart';
import 'chat.dart';

class ChatUsers {
  String name;
  String messageText;
  String imageURL;
  String time;
  ChatUsers(
      {required this.name,
      required this.messageText,
      required this.imageURL,
      required this.time});
}

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  List<ChatUsers> chatUsers = [
    ChatUsers(
        name: "Jane Russel",
        messageText: "Awesome Setup",
        imageURL: "images/userImage1.jpeg",
        time: "Now"),
    ChatUsers(
        name: "Glady's Murphy",
        messageText: "That's Great",
        imageURL: "images/userImage2.jpeg",
        time: "Yesterday"),
    ChatUsers(
        name: "Jorge Henry",
        messageText: "Hey where are you?",
        imageURL: "images/userImage3.jpeg",
        time: "31 Mar"),
    ChatUsers(
        name: "Philip Fox",
        messageText: "Busy! Call me in 20 mins",
        imageURL: "images/userImage4.jpeg",
        time: "28 Mar"),
    ChatUsers(
        name: "Debra Hawkins",
        messageText: "Thankyou, It's awesome",
        imageURL: "images/userImage5.jpeg",
        time: "23 Mar"),
    ChatUsers(
        name: "Jacob Pena",
        messageText: "will update you in evening",
        imageURL: "images/userImage6.jpeg",
        time: "17 Mar"),
    ChatUsers(
        name: "Andrey Jones",
        messageText: "Can you please share the file?",
        imageURL: "images/userImage7.jpeg",
        time: "24 Feb"),
    ChatUsers(
        name: "John Wick",
        messageText: "How are you?",
        imageURL: "images/userImage8.jpeg",
        time: "18 Feb"),
  ];

  bool private = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: private ? Text("Private chat") : Text("Public chat"),
        actions: <Widget>[_privateChatBtn],
        backgroundColor: primeColor,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        itemCount: chatUsers.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 16),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ConversationList(
            name: chatUsers[index].name,
            messageText: chatUsers[index].messageText,
            imageUrl: chatUsers[index].imageURL,
            time: chatUsers[index].time,
            isMessageRead: (index == 0 || index == 3) ? true : false,
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(
        index: 1,
      ),
    );
  }

  Widget get _privateChatBtn {
    return Row(
      children: [
        FittedBox(
          fit: BoxFit.fill,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(0, 4, 10, 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerRight,
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () => onTap(1),
            child: Container(
              decoration: BoxDecoration(
                  color: primeColorDark.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(6.0)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 23.0, vertical: 6.0),
                child: Text(
                  private ? "to public" : "to private",
                  // : "Sell",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void onTap(int option) {
    setState(() => private = !private);
  }
}
