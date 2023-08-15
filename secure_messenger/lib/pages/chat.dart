import 'package:flutter/material.dart';

import '../components/app_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../screens/chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Chat"),
      body: Chat(),
      bottomNavigationBar: BottomNavBar(
        index: 1,
      ),
    );
  }
}