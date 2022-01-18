import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/presentation/auth/register_user/widgets/register_user_form.dart';
import 'package:flutter/material.dart';

class RegisterUserPage extends StatelessWidget {
  final UserPhone _userPhone;
  const RegisterUserPage({
    Key? key,
    required UserPhone userPhone,
  }) : 
    _userPhone = userPhone,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
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
