import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/presentation/auth/register_user/widgets/register_user_form.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatelessWidget {
  final UserPhone _userPhone;
  const ChangePasswordPage({
    Key? key,
    required UserPhone userPhone,
  }) : 
    _userPhone = userPhone,
    super(key: key);

  @override
  Widget build(BuildContext context) {
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
        child: RegisterUserForm(
          userPhone: _userPhone,
        ),
      ),
    );
  }
}
