import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secure_messenger/utils/colors.dart';

import 'pages/authentication/login.dart';
import 'pages/authentication/signup.dart';
import 'pages/chat.dart';
import 'pages/contacts.dart';
import 'pages/profile.dart';
import 'pages/user_profile.dart';
import 'provider/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserDataProvider(),
      child: MaterialApp(
        title: 'Map Markers',
        theme: themeColors,
        debugShowCheckedModeBanner: false,
        initialRoute: '/contacts',
        routes: {
          '/login': (context) => LogIn(),
          '/signup': (context) => SignUp(),
          '/contacts': (context) => ContactPage(),
          '/chat': (context) => ChatPage(),
          '/profile': (context) => ProfilePage(),
          '/user-profile': (context) => UserProfilePage(),
        },
      ),
    );
  }
}