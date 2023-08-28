import 'package:flutter/cupertino.dart';
import 'package:secure_messenger/components/user_field.dart';

import '../provider/provider_manager.dart';

class SearchResult {
  final String email;
  final String name;

  Widget toWidget(
    BuildContext context, {
    required void Function() resetState,
    required void Function(String) setErrorState,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(children: [
        const SizedBox(height: 30),
        UserField(
          type: "Add",
          user: ProviderManager().getUser(context),
          username: name,
          email: email,
          resetState: resetState,
          setErrorState: setErrorState,
        ),
      ]),
    );
  }

  SearchResult({required this.email, required this.name});
}
