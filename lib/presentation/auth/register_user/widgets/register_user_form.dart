import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/register_user.dart';
import 'package:flowers_app/domain/auth/user_group.dart';
import 'package:flowers_app/domain/auth/user_password.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/domain/core/errors/failure.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class RegisterUserForm extends StatefulWidget {
  final UserPhone _userPhone;
  const RegisterUserForm({
    super.key,
    required UserPhone userPhone,
  }) : 
    _userPhone = userPhone;

  @override
  State<RegisterUserForm> createState() => _RegisterUserFormState();
}
//
//
class _RegisterUserFormState extends State<RegisterUserForm> {
  static const _log = Log('_RegisterUserFormState');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _userName = '';
  String _userLocation = '';
  late UserPassword _userPassword;
  //
  //
  @override
  void initState() {
    if (mounted) {
      const _length = 4; // будет сгенерирован пароль в формате xxxx-xxxx
      _userPassword = UserPassword.generate(_length, _length);
    }
    _log.debug('.initState | generated userPassword: ', _userPassword.value());
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      _log.debug('.build | _isLoading !!!');
      return const InProgressOverlay(
        isSaving: true,
        message: AppText.loading,
      );
    } else {
      return _buildSignInWidget(context);
    }
  }
  ///
  ///
  Widget _buildSignInWidget(BuildContext context) {
    _log.debug('.build | _buildSignInWidget');
    const paddingValue = 13.0;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        padding: const EdgeInsets.all(paddingValue * 2),
        children: [
          const SizedBox(height: 34.0),
          Text(
            'Ваши данные для связи и доставки',
            style: appThemeData.textTheme.bodyMedium,
          ),
          const SizedBox(height: paddingValue),
          TextFormField(
            style: appThemeData.textTheme.bodyMedium,
            maxLength: 50,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.account_box,
                // color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'ФИО',
              labelStyle: appThemeData.textTheme.bodyMedium,
              errorMaxLines: 3,
            ),
            autocorrect: false,
            validator: (value) => value is String && value.length >= 5 
              ? null
              : 'Не менее 5 символов',
            onChanged: (value) {
              setState(() {
                _userName = value;
              });
            },
          ),
          const SizedBox(height: paddingValue),
          TextFormField(
            style: appThemeData.textTheme.bodyMedium,
            maxLength: 50,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.location_pin,
                // color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'Населенный пункт',
              labelStyle: appThemeData.textTheme.bodyMedium,
              errorStyle: const TextStyle(
                height: 1.1,
              ),
              errorMaxLines: 5,
            ),
            autocorrect: false,
            validator: (value) => value is String && value.length >= 3 
              ? null
              : 'Не менее 3 символов',
            onChanged: (value) {
              setState(() {
                _userLocation = value;
              });
            },
          ),
          const SizedBox(height: paddingValue),
          TextFormField(
            style: appThemeData.textTheme.bodyMedium,
            maxLength: _userPassword.maxLength,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock,
                // color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'Пароль',
              labelStyle: appThemeData.textTheme.bodyMedium,
              errorStyle: const TextStyle(
                height: 1.1,
              ),
              errorMaxLines: 5,
            ),
            autocorrect: false,
            initialValue: _userPassword.value(),
            validator: (value) => _userPassword.validate().message(),
            onChanged: (value) {
              setState(() {
                _userPassword = UserPassword(value: value);
              });
            },
          ),
          const SizedBox(height: paddingValue),
          ElevatedButton(
            onPressed: isFormValid()
              ? _registerUser
              : null,
            child: const Text(AppText.next),
          ),
        ],
      ),
    );
  }
  ///
  ///
  bool isFormValid() {
    final formKeyCurrentState = _formKey.currentState;
    bool formValid = false;
    if (formKeyCurrentState != null) {
      formValid = formKeyCurrentState.validate();
    }
    return formValid;
  }
  ///
  ///
  void _registerUser() {
    setState(() {
      _isLoading = true;
    });
    RegisterUser(user: AppUser())
      .fetch(RegisterUserSqlParams(
        role: UserGroupList.customer,
        // email: _userEmail,
        phone: widget._userPhone.numberWithCode,
        name: _userName,
        location: _userLocation,
        login: widget._userPhone.numberWithCode,
        pass: _userPassword.encrypted(),
        account: '0.0',
        lastAct: 'null',
        blocked: 'null',
      ),)
      .then((result) {
        setState(() {
          _isLoading = false;
        });
        switch (result) {
          case Ok<AppUser, Failure>(:final value):
            _log.info('._registerUser | Registered! Result: $value');
            FlushbarHelper.createSuccess(
              duration: AppUiSettings.flushBarDuration,
              message: 'Вы успешно зарегистрировались.',
            ).show(context);
          case Err<AppUser, Failure>(:final error):
            _log.warning('._registerUser | Not registered, Error: $error');
            FlushbarHelper.createError(
              duration: AppUiSettings.flushBarDuration,
              message: '${error.message}',
            ).show(context);
        }
      });    
  }
}
