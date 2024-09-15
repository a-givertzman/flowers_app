import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/presentation/auth/sign_in/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
/// Sign in user if registered, or try to register
class SignInPage extends StatelessWidget {
  static const _log = Log("SignInPage");
  final Authenticate auth;
  final Widget Function(BuildContext context, AppUser user)? onSuccess;
  ///
  ///
  const SignInPage({
    super.key,
    required this.auth,
    this.onSuccess,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug(".build | onSuccess: $onSuccess");
    return PopScope(
      onPopInvokedWithResult: (bool didPop, _) async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(AppText.authentication),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SignInForm(
            auth: auth,
            onSuccess: onSuccess,
          ),
        ),
      ),
    );
  }
}
