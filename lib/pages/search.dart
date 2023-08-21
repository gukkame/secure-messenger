import 'package:flutter/material.dart';

import '../screens/search.dart';
import '../components/app_bar.dart';
import '../components/bottom_nav_bar.dart';

//Search page, where users can search other users and see if anyone has invited them.
//People are displayed in the list with buttons on side, accept/deny or send friend request

//Search by email

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: "Search for friends"),
      body: SearchScreen(),
      bottomNavigationBar: BottomNavBar(index: 3),
    );
  }
}
