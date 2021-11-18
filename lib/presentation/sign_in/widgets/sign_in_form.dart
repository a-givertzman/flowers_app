import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/In_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flutter/material.dart';

class SignInForm extends StatefulWidget {
  final Authenticate auth;
  const SignInForm({
    Key? key,
    required this.auth,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _first = true;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (_first) {
      _first = false;
      widget.auth.authenticateIfStored().then((authResult) {
        _setAuthState(authResult);
      });
    }
    return StreamBuilder(
      // stream: user.authStream,
      builder:(context, auth) {
        if (_isLoading) {
          print('_isLoading!!!');
          return const InProgressOverlay(isSaving: true);
        } else {
          print('_buildSignInWidget!!!');
          return _buildSignInWidget(context);
        }
      },
    );
  }
  void _setAuthState(AuthResult authResult) {
    if (authResult.authenticated()) {
      print('Authenticated!!!');
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) =>  PurchaseOverviewPage(
            dataSource: dataSource,
            user: authResult.user(),
          ),
        )              
      ).then((_) {
        setState(() {_isLoading = true;});
        widget.auth.logout().then((authResult) {
          setState(() {_isLoading = false;});
        });
      });
    } else {
      print('Not Authenticated!!!');
      if (authResult.message() != '') {
        FlushbarHelper.createError(
          // duration: flushBarDuration,
          message: authResult.message(),
        ).show(context);
      }
      setState(() {_isLoading = false;});
    }
  }

  Widget _buildSignInWidget(BuildContext context) {
    UserPhone _userPhone = UserPhone(phone: '');
    const paddingValue = 16.0;
    return Form(
      child: ListView(
        padding: const EdgeInsets.all(paddingValue),
        children: [
          Text(
            'Совместные закупки',
            style: appThemeData.textTheme.headline2,
          ),
          Text(
            'Добро пожаловать!',
            style: appThemeData.textTheme.subtitle2,
          ),
          const SizedBox(height: 70.0),
          Text(
            'Авторизуйтесь что бы продолжить...',
            style: appThemeData.textTheme.bodyText2,
          ),
          TextFormField(   
            style: appThemeData.textTheme.bodyText2,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'Номер телефона',
              labelStyle: appThemeData.textTheme.bodyText2,
            ),
            autocorrect: false,
            validator: (value) => _userPhone.validate().message(),
            onChanged: (phone) {
              _userPhone = UserPhone(phone: phone);
            }
          ),
          const SizedBox(height: paddingValue),
          TextButton(
            child: const Text('Отправить код'),
            onPressed: () {
          //TODO Implemente phone verification
            },
          ),
          const SizedBox(height: paddingValue),
          TextFormField(                                                    // Password field
            style: appThemeData.textTheme.bodyText2,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'Код из sms',
              labelStyle: appThemeData.textTheme.bodyText2,
              errorStyle: const TextStyle(
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
          TextButton(                                                   // Register Button
            child: const Text('Вход'),
            onPressed: () {
              setState(() {_isLoading = true;});
              widget.auth.authenticateByPhoneNumber(_userPhone.value())
                .then((authResult) {
                  _setAuthState(authResult);
                });
            },
          ),
        ],
      ),
    );
  }
}
