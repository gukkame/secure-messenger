import 'package:flutter/material.dart';

import '../components/app_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../screens/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile"),
      body: Profile(),
      bottomNavigationBar: BottomNavBar(
        index: 2,
      ),
    );
  }
}