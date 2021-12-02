import 'package:another_flushbar/flushbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/domain/auth/auth_result.dart';
import 'package:flowers_app/domain/auth/authenticate.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/In_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flowers_app/presentation/auth/register_user/register_user_page.dart';
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
  bool _codeSent = false;
  String _enteredOtp = '';
  late UserPhone _userPhone;
  _SignInFormState() {
    _userPhone = UserPhone(
      phone: '', 
      onCodeSent: _onCodeSent,
      onCompleted: _onCompleted,
      onVerificationFailed: _onVerificationFailed,
      onCodeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
    );
  }
  void _onCodeAutoRetrievalTimeout(String verId) {
    setState(() {
      _codeSent = false;
    });
  }
  void _onCompleted(PhoneAuthCredential phoneAuthCredential) {
    print('[_onCodeSent] str: $phoneAuthCredential');
    setState(() {_isLoading = true;});
    widget.auth.authenticateByPhoneNumber(_userPhone.value())
      .then((authResult) {
        _setAuthState(authResult);
      });
  }
  _onVerificationFailed(FirebaseAuthException exception) {
    FlushbarHelper.createError(
      duration: AppUiSettings.flushBarDuration,
      message: 'Проверьте номер телефона или попробуте познее, Ошибка ${exception.message}',
    ).show(context);
    setState(() {
      _codeSent = false;
    });
  }
  void _onCodeSent(String str, int? id) {
    setState(() {
      _codeSent = true;
    });
    print('[_onCodeSent] str: $str');
    print('[_onCodeSent] id: $id');
  }
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
          return const InProgressOverlay(
            isSaving: true,
            message: AppMessages.loadingMessage,
          );
        } else {
          return _buildSignInWidget(context, auth);
        }
      },
    );
  }
  void _setAuthState(AuthResult authResult) async {
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
          duration: AppUiSettings.flushBarDuration,
          message: authResult.message(),
        ).show(context);
      }
      await Future.delayed(AppUiSettings.flushBarDuration);
      setState(() {_isLoading = false;});
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  RegisterUserPage(
            user: authResult.user(),
          ),
        )
      ).then((isRegistered) {
        if (isRegistered) {
          _tryAuth(_userPhone.value());
        }
      });
    }
  }

  void _tryAuth(String userPhone) {
    setState(() {_isLoading = true;});
    widget
      .auth
      .authenticateByPhoneNumber(userPhone)
      .then((authResult) {
        _setAuthState(authResult);
      });
  }

  Widget _buildSignInWidget(BuildContext context, AsyncSnapshot<Object?> auth) {
    print('_buildSignInWidget!!!');
    const paddingValue = 13.0;
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        padding: const EdgeInsets.all(paddingValue * 2),
        children: [
          Text(
            'Совместные закупки',
            style: appThemeData.textTheme.headline2,
          ),
          Text(
            'Добро пожаловать!',
            style: appThemeData.textTheme.subtitle2,
          ),
          const SizedBox(height: 34.0),
          Text(
            'Авторизуйтесь что бы продолжить...',
            style: appThemeData.textTheme.bodyText2,
          ),
          const SizedBox(height: paddingValue),
          TextFormField(
            style: appThemeData.textTheme.bodyText2,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.phone,
                color: appThemeData.colorScheme.onPrimary,
              ),
              prefixText: '+7',
              prefixStyle: appThemeData.textTheme.bodyText2,
              labelText: 'Номер телефона',
              labelStyle: appThemeData.textTheme.bodyText2,
              errorMaxLines: 3,
            ),
            autocorrect: false,
            validator: (value) => _userPhone.validate().message(),
            onChanged: (phone) {
              setState(() {
                _userPhone = UserPhone(
                  phone: phone, 
                  onCodeSent: _onCodeSent,
                  onCompleted: _onCompleted,
                  onVerificationFailed: _onVerificationFailed,
                  onCodeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
                );
              });
            },
          ),
          const SizedBox(height: paddingValue),
          ElevatedButton(
            child:  const Text('Отправить код'),
            onPressed: _userPhone.validate().valid() && !_codeSent
            ? () {
              if (_userPhone.validate().valid()) {
                print('Sending code');
                _userPhone.verifyPhone();
                setState(() {
                  _codeSent = true;
                });
                FocusScope.of(context).unfocus();
              } else {
                print('Phone number ${_userPhone.value()} is not valid');
              }
            }
            : null,
          ),
          const SizedBox(height: paddingValue),
          TextFormField(
            style: appThemeData.textTheme.bodyText2,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'Код из смс',
              labelStyle: appThemeData.textTheme.bodyText2,
              errorStyle: const TextStyle(
                height: 1.1,
              ),
              errorMaxLines: 5,
            ),
            autocorrect: false,
            onChanged: (value) {
              _enteredOtp = value;
            }
          ),
          const SizedBox(height: paddingValue),
          ElevatedButton(
            child: const Text('Вход'),
            onPressed: () {
              _tryAuth(_userPhone.value());
            }
            // _codeSent
            // ?  () {
            //     _userPhone.verifyOtp(_enteredOtp)
            //       .then((verified) {
            //         if (verified) {
            //           setState(() {_isLoading = true;});
            //           widget.auth.authenticateByPhoneNumber(_userPhone.value())
            //             .then((authResult) {
            //               _setAuthState(authResult);
            //             });
            //         } else {
            //           FlushbarHelper.createError(
            //             duration: AppUiSettings.flushBarDuration,
            //             message: 'Неверный код',
            //           ).show(context);
            //         }
            //       });
            //   }
            // : null,
          ),
        ],
      ),
    );
  }
}
