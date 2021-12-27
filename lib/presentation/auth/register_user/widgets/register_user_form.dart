import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/register_user.dart';
import 'package:flowers_app/domain/auth/user_group.dart';
import 'package:flowers_app/domain/auth/user_password.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flutter/material.dart';

class RegisterUserForm extends StatefulWidget {
  final UserPhone _userPhone;
  const RegisterUserForm({
    Key? key,
    required UserPhone userPhone,
  }) : 
    _userPhone = userPhone,
    super(key: key);

  @override
  State<RegisterUserForm> createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _userName = '';
  String _userLocation = '';
  late UserPassword _userPassword;

  @override
  void initState() {
    if (mounted) {
      const _length = 4; // будет сгенерирован пароль в формате xxxx-xxxx
      _userPassword = UserPassword.generate(_length, _length);
    }
    log('[_RegisterUserFormState.initState] generated userPassword: ', _userPassword.value());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: user.authStream,
      builder:(context, auth) {
        if (_isLoading) {
          log('[_RegisterUserFormState.build] _isLoading !!!');
          return const InProgressOverlay(
            isSaving: true,
            message: AppText.loading,
          );
        } else {
          return _buildSignInWidget(context, auth);
        }
      },
    );
  }

  Widget _buildSignInWidget(BuildContext context, AsyncSnapshot<Object?> auth) {
    log('[_RegisterUserFormState.build] _buildSignInWidget');
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
            style: appThemeData.textTheme.bodyText2,
          ),
          const SizedBox(height: paddingValue),
          TextFormField(
            style: appThemeData.textTheme.bodyText2,
            maxLength: 50,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.account_box,
                color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'ФИО',
              labelStyle: appThemeData.textTheme.bodyText2,
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
            style: appThemeData.textTheme.bodyText2,
            maxLength: 50,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.location_pin,
                color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'Населенный пункт',
              labelStyle: appThemeData.textTheme.bodyText2,
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
            style: appThemeData.textTheme.bodyText2,
            maxLength: _userPassword.maxLength,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock,
                color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'Пароль',
              labelStyle: appThemeData.textTheme.bodyText2,
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
  bool isFormValid() {
    final formKeyCurrentState = _formKey.currentState;
    bool formValid = false;
    if (formKeyCurrentState != null) {
      formValid = formKeyCurrentState.validate();
    }
    return formValid;
  }
  void _registerUser() {
    setState(() {
      _isLoading = true;
    });
    RegisterUser(
      remote: dataSource.dataSet<Map<String, dynamic>>('set_client'),
      group: UserGroup.normal,
      location: _userLocation,
      name: _userName,
      phone: widget._userPhone.number(),
      pass: _userPassword.encrypted(),
    )
      .fetch()
      .then((response) {
        if(!response.hasError()) {
          Navigator.pop(context, true);
          FlushbarHelper.createSuccess(
            duration: AppUiSettings.flushBarDuration,
            message: 'Вы зарегистрированы, сохраните ваш логин и пароль.',
          ).show(context);
        } else {
          FlushbarHelper.createError(
            duration: AppUiSettings.flushBarDuration,
            message: response.errorMessage(),
          ).show(context);
        }
      });
  }
}
