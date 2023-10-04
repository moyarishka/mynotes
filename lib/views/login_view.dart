import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/errors.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/utilities/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(hintText: 'Enter your Email'),
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _password,
            decoration: const InputDecoration(hintText: 'Enter your Password'),
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    )
                    .then((value) => Navigator.of(context)
                        .pushNamedAndRemoveUntil(
                            RouteConstants.notes, (route) => false));
              } on FirebaseAuthException catch (e) {
                if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
                  await showErrorDialog(
                    context,
                    ErrorConstants.userNotFound,
                  );
                } else if (e.code == 'wrong-password') {
                  await showErrorDialog(
                    context,
                    ErrorConstants.wrongPassword,
                  );
                } else {
                  await showErrorDialog(
                    context,
                    'Error ${e.code}',
                  );
                }
              } catch (e) {
                await showErrorDialog(
                  context,
                  'Error $e',
                );
              }
            },
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  RouteConstants.register, (route) => false);
            },
            child: const Text('Register Here'),
          ),
        ],
      ),
    );
  }
}
