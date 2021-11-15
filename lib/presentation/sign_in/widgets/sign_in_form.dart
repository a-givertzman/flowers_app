import 'package:flowers_app/domain/user/user.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.authStream,
      builder:(context, auth) {
        return _buildSignInWidget(context, user);
      },
    );
  }

  Widget _buildSignInWidget(context, User user) {
    const paddingValue = 8.0;
    return Form(
      // autovalidateMode: user.showErrorMessages,
      child: ListView(
        padding: const EdgeInsets.all(paddingValue),
        children: [
          const Text(
            'Добро,\nпожаловать!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40),
          ),
          const SizedBox(height: paddingValue),
          TextFormField(                                                    // Email field
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: 'Номер телефона',
            ),
            autocorrect: false,
            onChanged: (value) {
              //TODO Implemente Номер телефона changed
            }
          ),
          const SizedBox(height: paddingValue),
          TextFormField(                                                    // Password field
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.lock),
              labelText: 'Фамилия',
              errorStyle: TextStyle(
                height: 1.1,
              ),
              errorMaxLines: 5,
            ),
            autocorrect: false,
            obscureText: true,
            onChanged: (value) {
              //TODO Implemente Номер телефона changed
            }
          ),
          const SizedBox(height: paddingValue),
          Row(children: [
            Expanded(child:
              TextButton(                                                   // Sign In Button
                child: const Text('Получить код'),
                onPressed: () {
              //TODO Implemente phone verification
                },
              ),
            ),
            Expanded(child:
              TextButton(                                                   // Register Button
                child: const Text('Зарегистрироваться'),
                onPressed: () {
                  //TODO Implemente register new user
                },
              ),
            ),
          ],),
          ElevatedButton(                                                   // Sign In with Google
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
            ),                                                   // Sign In with Google
            child: const Text(
              'Sign in with Google',
            ),
          ),
          ElevatedButton(
            onPressed: () {
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
            ),
            child: const Text(
              'Sign in with Facebook',
            ),
          ),
          if(user.isRequesting) ...[
            const SizedBox(height: paddingValue,),
            const LinearProgressIndicator(),
          ],
        ],
      ),
    );
  }
}
