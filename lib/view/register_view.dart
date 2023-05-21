import 'package:flutter/material.dart';
import 'package:todo_with_login/services/auth/auth_exceptions.dart';
import 'package:todo_with_login/services/auth/auth_services.dart';
import 'package:todo_with_login/utilities/constant.dart';
import 'package:todo_with_login/utilities/show_error_dailog.dart';
import 'package:todo_with_login/view/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text('Register'),
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
              child: const Text('Register'),
              onPressed: () async {
                final email = _email.text;
                final pass = _password.text;
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: pass,
                  );
                  _email.clear();
                  _password.clear();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const LoginView(),
                      ),
                      (Route<dynamic> route) => false);
                } on WeakPasswordAuthException {
                  showErrorDialog(context, 'weak password');
                } on EmailAlreadyInUseAuthException {
                  showErrorDialog(context,
                      'already register with this email please chane email');
                } on InvalidEmailAuthException {
                  showErrorDialog(context, 'Email inValid');
                } on GenericAuthException {
                  showErrorDialog(context, 'Error Please try Again');
                } catch (e) {
                  showErrorDialog(context, 'Error please try Again');
                }
              },
            ),
            TextButton(
              child: const Text('Already Registered? Login here'),
              onPressed: () async {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
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
