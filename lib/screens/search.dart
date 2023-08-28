import 'package:flutter/material.dart';
import 'package:secure_messenger/components/search_result.dart';

import '../api/search_api.dart';
import '../provider/provider_manager.dart';
import '../components/container.dart';
import '../utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<SearchResult>? users;
  Widget _infoTextWidget = const SizedBox.shrink();
  bool _searchLock = false;

  @override
  void initState() {
    _setInfoWidget("Search by name or email");
    super.initState();
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

  Widget get _searchButton {
    return Expanded(
      flex: 1,
      child: TextButton(
          onPressed: _searchLock ? () {} : _onSearchSubmit,
          style: TextButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.centerRight),
          child: Container(
            decoration: BoxDecoration(
                gradient: primeGradient,
                borderRadius: BorderRadius.circular(12.0)),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 13.5),
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
            ),
          )),
    );
  }

  void _onSearchSubmit() async {
    setState(() => _searchLock = true);
    if (_formKey.currentState!.validate()) {
      if (_searchController.value.text ==
          ProviderManager().getUser(context).email) {
        _setErrorState("Can't add yourself as a friend.");
      } else {
        setState(() => _setInfoWidget("Loading..."));
        users = await SearchApi().getUser(context, input: _searchController.value.text);
        if (users == null) {
          setState(() {
            _setErrorState("Internal server error, please try again.");
          });
        } else if (users!.isEmpty) {
          setState(() {
            _setErrorState("No user found.");
          });
        }
      }
    } else {
      debugPrint("Invalid");
    }
    setState(() => _searchLock = false);
  }

  List<Widget> get _userWidgets {
    return users != null ? _usersFound(users as List<SearchResult>) : const [];
  }

  List<Widget> _usersFound(List<SearchResult> data) {
    _setInfoWidget("User found!");
    Future.delayed(Duration.zero).then((_) => setState(() {}));
    return List.generate(
        data.length,
        (index) => data[index].toWidget(
              context,
              resetState: _resetState,
              setErrorState: _setErrorState,
            ));
  }

  void _resetState() {
    setState(() {
      users = null;
      _searchController.value = TextEditingValue.empty;
    });
    Future.delayed(Duration.zero).then((value) {
      _setInfoWidget("Friend request sent!");
      setState(() {});
    });
  }

  void _setErrorState(String msg) {
    _setInfoWidget(msg);
    setState(() {
      users = null;
    });
  }

  void _setInfoWidget(String msg) {
    _infoTextWidget = Center(
        child: Text(
      msg,
      style: const TextStyle(
        color: primeColorTrans,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    ));
  }

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
          ..._userWidgets,
        ],
      ),
    );
  }
}
