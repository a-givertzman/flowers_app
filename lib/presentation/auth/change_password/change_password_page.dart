import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/presentation/auth/change_password/widgets/change_password_form.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  static const _debug = false;
  final AppUser _user;
  const ChangePasswordPage({
    Key? key,
    required AppUser user,
  }) : 
    _user = user,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$ChangePasswordPage.build] user: ', _user);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(AppText.changingPassword),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      body: Center(
        child: ChangePasswordForm(
          user: _user,
        ),
      ),
    );
  }
}
