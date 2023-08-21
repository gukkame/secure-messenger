import 'package:flutter/material.dart';

import '../../screens/invites.dart';
import '../components/app_bar.dart';
import '../components/bottom_nav_bar.dart';

class InvitePage extends StatefulWidget {
  const InvitePage({super.key});

  @override
  State<InvitePage> createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Invites"),
      body: InviteScreen(),
      bottomNavigationBar: const BottomNavBar(
        index: 2,
      ),
    );
  }
}
