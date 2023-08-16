import 'package:flutter/material.dart';

import '../components/container.dart';
import '../utils/colors.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? user;
  final Widget _infoTextWidget = const SizedBox.shrink();
  final bool _searchLock = false;
  final String _searchedEmail = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 100, 30, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedGradientContainer(
            gradient: primeGradient,
            borderSize: 2,
            child: Flex(
              direction: Axis.horizontal,
              children: [
                _searchField,
                _searchButton,
              ],
            ),
          ),
          const SizedBox(height: 40),
          _infoTextWidget,
          const Text("searched user"),
          // _userWidget,
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Contact list ",
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w500, color: primeColor),
          ),
          const SizedBox(
            height: 20,
          ),
          _contactList,
        ],
      ),
    );
  }

  void search() {
    debugPrint("Search button pressed");
    // navigate(context, "/search");
  }

  Widget get _searchButton {
    return TextButton(
        onPressed: search,
        style: TextButton.styleFrom(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerRight),
        child: Container(
          decoration: BoxDecoration(
              gradient: primeGradient,
              borderRadius: BorderRadius.circular(5.0)),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.5),
            child: Text(
              "Search",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
        ));
  }

  Widget get _searchField {
    return Expanded(
      flex: 2,
      child: Form(
        key: _formKey,
        child: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              hintText: "Search by email",
              border: InputBorder.none),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Input required";
            } else {
              return null;
            }
          },
        ),
      ),
    );
  }

  Widget get _contactList {
    return const Column(
      children: [Text("friend 1 "), Text("friend 2")],
    );
  }
}
