import 'package:flowers_app/assets/texts/app_text.dart';
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppText.authentication),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SignInForm(
            auth: auth,
          ),
        ),
      ),
    );
  }
}
