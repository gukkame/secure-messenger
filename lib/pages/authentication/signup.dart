import 'package:flutter/material.dart';
import '../../provider/provider_manager.dart';
import '../../components/container.dart';
import '../../components/scaffold.dart';
import '../../utils/colors.dart';
import '../../utils/user.dart';
import '../../utils/navigation.dart';

class SignUp extends StatefulWidget {
  final user = User();
  final double _scaffoldBorderRadius;
  get borderRadius => _scaffoldBorderRadius;
  SignUp({super.key, double scaffoldBorderRadius = 20.0})
      : _scaffoldBorderRadius = scaffoldBorderRadius;
  @override
  State<SignUp> createState() => _AddNoteState();
}

class _AddNoteState extends State<SignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _passErrMsg;
  String? _emailErrMsg;
  String? _loadingText;
  BorderColor usernameCheck = BorderColor.neutral;
  BorderColor emailCheck = BorderColor.neutral;
  BorderColor passCheck = BorderColor.neutral;
  BorderColor pass2Check = BorderColor.neutral;
  bool _submitLock = false;

  Widget _createInputField(
    String hintText,
    BorderColor checker,
    TextEditingController controller,
    String? Function(String?) validator, {
    String? errorText,
    bool obscureText = false,
  }) {
    return RoundedGradientContainer(
      gradient: checker == BorderColor.error
          ? errorGradient
          : checker == BorderColor.correct
              ? correctGradient
              : null,
      child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: checker == BorderColor.error ? 5 : 0,
          ),
          child: TextFormField(
            obscureText: obscureText,
            enableSuggestions: false,
            autocorrect: false,
            controller: controller,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                hintText: hintText,
                errorText: errorText,
                border: checker != BorderColor.error ? InputBorder.none : null),
            validator: validator,
          )),
    );
  }

  Widget get _usernameField => _createInputField(
        "Username",
        usernameCheck,
        _usernameController,
        _validateUsernameField,
      );
  Widget get _emailField => _createInputField(
        "Email",
        emailCheck,
        _emailController,
        _validateEmailField,
        errorText: _emailErrMsg,
      );
  Widget get _passwordField => _createInputField(
        "Password",
        passCheck,
        _passwordController,
        _validatePasswordField,
        errorText: _passErrMsg,
        obscureText: true,
      );
  Widget get _password2Field => _createInputField(
        "Repeat Password",
        pass2Check,
        _password2Controller,
        _validatePassword2Field,
        obscureText: true,
      );
  Widget get _loading {
    return _loadingText == null
        ? const SizedBox.shrink()
        : Text(
            _loadingText as String,
            style: const TextStyle(
              color: primeColor,
              fontSize: 17,
            ),
          );
  }

  Widget get _redirectLoginButton {
    return InkWell(
      onTap: () => navigate(context, "/login"),
      child: const Text(
        "Already have an account? Click here!",
        style: TextStyle(
            fontSize: 14, color: primeColor, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget get _submitButton {
    return TextButton(
        onPressed: _submitLock ? () {} : _onSubmit,
        child: Container(
          decoration: BoxDecoration(
              gradient: primeGradient,
              borderRadius: BorderRadius.circular(20.0)),
          child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              )),
        ));
  }

  String? _validateUsernameField(String? value) {
    if (value == null || value.isEmpty || value.length < 4) {
      usernameCheck = BorderColor.error;
      return "Username required";
    }
    usernameCheck = BorderColor.correct;
    return null;
  }

  String? _validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      emailCheck = BorderColor.error;
      return "Email required";
    } else if (!value.contains("@") ||
        !value.contains(".") ||
        value.length < 4) {
      emailCheck = BorderColor.error;
      return "Email is wrong";
    }
    emailCheck = BorderColor.correct;
    return null;
  }

  String? _validatePasswordField(String? value) {
    if (value == null ||
        value.isEmpty ||
        value != _password2Controller.value.text) {
      passCheck = BorderColor.error;
      return "Password required";
    }
    passCheck = BorderColor.correct;
    return null;
  }

  String? _validatePassword2Field(String? value) {
    if (value == null ||
        value.isEmpty ||
        value != _passwordController.value.text) {
      pass2Check = BorderColor.error;
      return "Password incorrect or doesn't match";
    }
    pass2Check = BorderColor.correct;
    return null;
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _removeAllNegativeCheckers();
      setState(() {
        _loadingText = "Processing data...";
        _submitLock = true;
      });
      var name = _usernameController.value.text;
      var email = _emailController.value.text;
      var password = _passwordController.value.text;
      String? resp = await widget.user.registerUser(
        name: name,
        email: email,
        password: password,
      );
      if (resp == null) {
        _saveUser();
      } else {
        setState(() {
          _loadingText = null;
          _submitLock = false;
        });
        _handleDBRejection(resp);
        setState(() => {});
      }
    } else {
      debugPrint("Invalid");
      setState(() {
        _loadingText = null;
        _submitLock = false;
      });
    }
  }

  void _handleDBRejection(String msg) {
    switch (msg) {
      case 'weak-password':
        passCheck = BorderColor.error;
        pass2Check = BorderColor.error;
        _passErrMsg = 'Password is too weak.';
        break;
      case 'email-already-in-use':
        emailCheck = BorderColor.error;
        _emailErrMsg = 'Account already exists with this email.';
      case 'invalid-email':
        emailCheck = BorderColor.error;
        _emailErrMsg = 'Invalid email address';
        break;
      default:
        _loadingText =
            "Internal server error. Please contact support or try again.";
        usernameCheck = BorderColor.error;
        emailCheck = BorderColor.error;
        passCheck = BorderColor.error;
        pass2Check = BorderColor.error;
    }
  }

  void _saveUser() {
    debugPrint("User registered successfully! redirecting...");
    ProviderManager().setUser(context, widget.user);
    navigate(context, "/contacts");
  }

  void _removeAllNegativeCheckers() {
    _passErrMsg = null;
    _emailErrMsg = null;
    _loadingText = null;
    usernameCheck = BorderColor.neutral;
    emailCheck = BorderColor.neutral;
    passCheck = BorderColor.neutral;
    pass2Check = BorderColor.neutral;
  }

  @override
  Widget build(BuildContext context) {
    return RoundScaffold(
      title: "Stock Market",
      rounding: widget.borderRadius,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 28,
                    color: primeColor,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 28,
              ),
              _usernameField,
              const SizedBox(height: 20),
              _emailField,
              const SizedBox(height: 20),
              _passwordField,
              const SizedBox(height: 20),
              _password2Field,
              SizedBox(height: _loadingText != null ? 20 : 0),
              _loading,
              const SizedBox(height: 20),
              _redirectLoginButton,
              const SizedBox(height: 30),
              _submitButton,
            ],
          ),
        ),
      ),
    );
  }
}

enum BorderColor { neutral, error, correct }
