import 'package:flutter/material.dart';

import '../api/friends_api.dart';
import '../components/menu_button.dart';
import '../components/user_field.dart';
import '../provider/provider_manager.dart';
import '../utils/colors.dart';
import '../utils/user.dart';

class InviteScreen extends StatefulWidget {
  final FriendsApi api = FriendsApi();

  InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  late User user;
  String errorMSg = "Users not found";
  bool inbound = true;
  bool outbound = false;
  List<MapEntry<String, dynamic>> inboundUsers = [];
  List<MapEntry<String, dynamic>> outboundUsers = [];

  @override
  void initState() {
    user = ProviderManager().getUser(context);
    getInvReq();
    super.initState();
  }

  void getInvReq() async {
    debugPrint("called getInvReq");
    var allData = await widget.api.getFriends(user);
    inboundUsers = allData.containsKey("inbound")
        ? allData["inbound"].entries.toList()
        : inboundUsers;
    outboundUsers = allData.containsKey("outbound")
        ? allData["outbound"].entries.toList()
        : outboundUsers;

    debugPrint("inbound: $allData");
    debugPrint("inbound: $inboundUsers");
    debugPrint("outbound: $outboundUsers");
    debugPrint("new dada added");
    setState(() {});
  }

  Widget get _menu {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        MenuButton(
            title: "Inbound", pressed: inbound, switchButtons: onPressed),
        MenuButton(
            title: "Outbound", pressed: outbound, switchButtons: onPressed),
      ],
    );
  }

  void onPressed(type) {
    if (type == "Inbound" && !inbound || type == "Outbound" && !outbound) {
      inbound = !inbound;
      outbound = !outbound;
      getInvReq();
    }
  }

  Widget get _setInfoWidget {
    return Center(
        child: Text(
      errorMSg,
      style: const TextStyle(
        color: primeColorTrans,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    ));
  }

  void _setErrorState(String msg) {
    errorMSg = msg;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
      child: Column(
        children: [
          _menu,
          const SizedBox(height: 30),
          Column(
            children: [
              if (inbound && inboundUsers.isNotEmpty)
                for (var userIn in inboundUsers)
                  UserField(
                      type: "Inbound",
                      user: user,
                      username: userIn.value,
                      email: userIn.key,
                      resetState: getInvReq,
                      setErrorState: _setErrorState)
              else if (!inbound && outboundUsers.isNotEmpty)
                for (var userOut in outboundUsers)
                  UserField(
                      type: "Outbound",
                      user: user,
                      username: userOut.value,
                      email: userOut.key,
                      resetState: () => {},
                      setErrorState: _setErrorState)
              else
                _setInfoWidget
            ],
          )
        ],
      ),
    );
  }
}
