import 'package:flutter/material.dart';

import '../api/friends_api.dart';
import '../../api/search_api.dart';
import '../api/invites_api.dart';
import '../utils/colors.dart';
import '../utils/user.dart';
import 'container.dart';
import 'note_state.dart';

class UserField extends StatefulWidget {
  final String type;
  final NoteState? state;
  final User user;
  final String username;
  final String email;
  final void Function() resetState;
  final void Function(String) setErrorState;

  const UserField({
    super.key,
    required this.type,
    this.state,
    required this.user,
    required this.username,
    required this.email,
    required this.resetState,
    required this.setErrorState,
  });

  @override
  State<UserField> createState() => _UserFieldState();
}

class _UserFieldState extends State<UserField> {
  bool deleted = false;

  void _deleteFriend() async {
    var resp = await FriendsApi().removeFriend(widget.user, widget.email);
    if (resp != null) {
      widget.setErrorState(resp);
    } else {
      setState(() {
        deleted = true;
      });
      widget.resetState();
    }
  }

  void _acceptFriendRequest() async {
    var resp = await InvitesApi()
        .acceptInvite(widget.user, widget.email, widget.username);
    if (resp != null) {
      widget.setErrorState("You already accepted friend request!");
    } else {
      debugPrint("accepted friend request: $resp");
      widget.resetState();
    }
  }

  void _declineFriendRequest() async {
    var resp = await InvitesApi()
        .declineInvite(widget.user, widget.email, widget.username);
    if (resp != null) {
      widget.setErrorState("Cant decline friend request");
    } else {
      debugPrint("declined friend request: $resp");
      widget.resetState();
    }
  }

  void _sendFriendRequest() async {
    var resp = await SearchApi()
        .sendFriendRequest(widget.user, widget.email, widget.username);
    if (resp != null) {
      widget.setErrorState(
          "This user is already your friend or\nyou've already sent them a friend request!");
    } else {
      widget.resetState();
    }
  }

  Widget get _deleteBtn {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(0.0),
        decoration: BoxDecoration(
            gradient: primeGradient,
            borderRadius: BorderRadius.circular(200.0)),
        child: IconButton(
          style: const ButtonStyle(
            overlayColor: MaterialStatePropertyAll(Colors.transparent),
          ),
          icon: const Icon(
            Icons.remove,
            size: 32,
            color: Colors.white,
          ),
          onPressed: _deleteFriend,
        ),
      ),
    );
  }

  Widget get _acceptBtn {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerRight),
      onPressed: _acceptFriendRequest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 11.0),
        child: Text(
          "Accept",
          style: TextStyle(
              color: primeColor.withOpacity(0.9),
              fontWeight: FontWeight.bold,
              fontSize: 14.0),
        ),
      ),
    );
  }

  Widget get _declineBtn {
    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerRight),
      onPressed: _declineFriendRequest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 11.0),
        child: Text(
          "Decline",
          style: TextStyle(
              color: primeColor.withOpacity(0.9),
              fontWeight: FontWeight.bold,
              fontSize: 14.0),
        ),
      ),
    );
  }

  Widget get _button {
    void Function()? action;
    String title = "";
    if (widget.type == "Add") {
      action = _sendFriendRequest;
      title = "Add";
    } else if (widget.type == "Outbound") {
      title = "Invited";
    } else if (widget.type == "Friend") {
      return const SizedBox(
        height: 50,
      );
    } else if (widget.type == "Inbound") {
      return Row(
        children: [
          _declineBtn,
          _acceptBtn,
        ],
      );
    }

    return TextButton(
      style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerRight),
      onPressed: action,
      child: Container(
        decoration: widget.type == "Outbound"
            ? BoxDecoration(
                color: primeColorTrans,
                borderRadius: BorderRadius.circular(12.0),
              )
            : BoxDecoration(
                gradient: primeGradient,
                borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 11.0),
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return deleted
        ? const SizedBox.shrink()
        : Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: RoundedGradientContainer(
                      borderSize: 2,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.username,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              _button
                            ],
                          )),
                    ),
                  ),
                  if (widget.state == NoteState.delete) ...[
                    const SizedBox(
                      width: 20,
                    ),
                    _deleteBtn
                  ] else
                    const SizedBox.shrink()
                ],
              ),
            ],
          );
  }
}
