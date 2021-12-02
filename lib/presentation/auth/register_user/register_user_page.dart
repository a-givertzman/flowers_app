import 'package:flowers_app/domain/auth/user.dart';
import 'package:flowers_app/presentation/auth/register_user/widgets/register_user_form.dart';
import 'package:flutter/material.dart';

class RegisterUserPage extends StatelessWidget {
  final User user;
  const RegisterUserPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регистрация'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      body: Center(
        child: RegisterUserForm(
          user: user,
        ),
      ),
    );
  }
}
