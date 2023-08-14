import 'package:firebase_auth/firebase_auth.dart';
import '../api/user_api.dart';

class User {
  late UserCredential credential;
  late String email;
  late String name;
  double? lat;
  double? lng;

  Future<String?> signInUser(
      {required String email, required String password}) async {
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      this.email = email;
      String? username = await UserApi().getUsername(email: email);
      if (username == null) {
        return "Unable to get the username from the database";
      }
      name = username;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return "Unknown error: ${e.toString()}";
    }
    return null;
  }

  Future<String?> registerUser(
      {required String name,
      required String email,
      required String password}) async {
    try {
      credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(name);
      this.email = email;
      this.name = name;

      var resp = await UserApi()
          .registerNewUser(email: email, name: name, password: password);
      if (!resp) return "Internal server error. Please contact support.";
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return "Unknown error: ${e.toString()}";
    }

    return null;
  }

  User();
}
