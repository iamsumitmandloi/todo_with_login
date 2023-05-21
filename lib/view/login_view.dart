import 'package:flutter/material.dart';
import 'package:todo_with_login/services/auth/auth_exceptions.dart';
import 'package:todo_with_login/services/auth/auth_services.dart';
import 'package:todo_with_login/utilities/constant.dart';
import 'package:todo_with_login/utilities/show_error_dailog.dart';
import 'package:todo_with_login/view/home_screen.dart';
import 'package:todo_with_login/view/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(
                border: border,
                hintText: 'Enter Email',
              ),
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: _password,
              decoration: InputDecoration(
                border: border,
                hintText: 'Enter Password',
              ),
              enableSuggestions: false,
              autocorrect: false,
              obscureText: true,
            ),
            TextButton(
              child: const Text('Login'),
              onPressed: () async {
                final email = _email.text;
                final pass = _password.text;
                try {
                  await AuthService.firebase().logIn(
                    email: email,
                    password: pass,
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (Route<dynamic> route) => false);
                } on UserNotFoundAuthException {
                  await showErrorDialog(
                    context,
                    'User not found',
                  );
                } on WrongPasswordAuthException {
                  await showErrorDialog(
                    context,
                    'Wrong password',
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    'Authentication error',
                  );
                } catch (e) {
                  await showErrorDialog(
                    context,
                    'some error occurred , Please try Again',
                  );
                }
                // dev.log(userCredential);
              },
            ),
            // SizedBox(height: 20,),
            TextButton(
              child: const Text('Not Registered yet? Register here'),
              onPressed: () async {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const RegisterView(),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
