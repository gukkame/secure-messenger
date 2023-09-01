import 'package:flutter/material.dart';

import '../../components/app_bar.dart';
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
    return const Scaffold(
      appBar: CustomAppBar(title: "Contacts"),
      body: Contacts(),
      bottomNavigationBar: BottomNavBar(
        index: 0,
      ),
    );
  }
}
