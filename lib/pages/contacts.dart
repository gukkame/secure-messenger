import 'package:flutter/material.dart';
import 'package:secure_messenger/components/app_bar.dart';

import '../components/bottom_nav_bar.dart';
import '../screens/contacts.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Contacts"),
      body: const Contacts(),
      bottomNavigationBar: const BottomNavBar(
        index: 0,
      ),
    );
  }
}
