import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/presentation/auth/sign_in/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final Authenticate auth;
  const SignInPage({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SignInForm(
          auth: auth,
        ),
      ),
    );
  }
}
