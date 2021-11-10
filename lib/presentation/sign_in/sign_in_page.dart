import 'package:flowers_app/domain/user/user.dart';
import 'package:flowers_app/presentation/sign_in/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final User  user;
  const SignInPage({
    required this.user,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SignInForm(
          user: user,
          //TODO Current user to be implemented
        ),
      ),
    );
  }
}
