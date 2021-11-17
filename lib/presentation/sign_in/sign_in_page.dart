import 'package:flowers_app/presentation/sign_in/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage(
  ) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: SignInForm(
        ),
      ),
    );
  }
}
