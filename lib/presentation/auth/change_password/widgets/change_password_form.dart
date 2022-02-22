import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/auth/app_user.dart';
import 'package:flowers_app/domain/auth/register_user.dart';
import 'package:flowers_app/domain/auth/user_group.dart';
import 'package:flowers_app/domain/auth/user_password.dart';
import 'package:flowers_app/domain/auth/user_phone.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:flutter/material.dart';

class ChangePasswordForm extends StatefulWidget {
  final AppUser _user;
  const ChangePasswordForm({
    Key? key,
    required AppUser user,
  }) : 
    _user = user,
    super(key: key);
  AppUser get user => _user;
  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  static const _debug = false;
  final _formKey = GlobalKey<FormState>();
  late AppUser _user;
  late UserPassword _userPassword;
  late UserPhone _userPhone;
  bool _isLoading = false;
  String _userName = '';
  String _userLocation = '';

  @override
  void initState() {
    if (mounted) {
      _user = widget.user;
      _userPhone = UserPhone(phone: '${_user['phone']}');
      // const _length = 4; // будет сгенерирован пароль в формате xxxx-xxxx
      _userPassword = UserPassword(value: UserPassword(value: '${_user['pass']}').decrypted());
      _userName = '${_user['name']}';
      _userLocation = '${_user['location']}';
    }
    log(_debug, '[$_ChangePasswordFormState.initState] generated userPassword: ', _userPassword.value());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: user.authStream,
      builder:(context, auth) {
        if (_isLoading) {
          log(_debug, '[$_ChangePasswordFormState.build] _isLoading !!!');
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
    log(_debug, '[$_ChangePasswordFormState.build] _buildSignInWidget');
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
              prefixIcon: const Icon(
                Icons.account_box,
                // color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'ФИО',
              labelStyle: appThemeData.textTheme.bodyText2,
              errorMaxLines: 3,
            ),
            autocorrect: false,
            initialValue: _userName,
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
              prefixIcon: const Icon(
                Icons.location_pin,
                // color: appThemeData.colorScheme.onPrimary,
              ),
              labelText: 'Населенный пункт',
              labelStyle: appThemeData.textTheme.bodyText2,
              errorStyle: const TextStyle(
                height: 1.1,
              ),
              errorMaxLines: 5,
            ),
            autocorrect: false,
            initialValue: _userLocation,
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
              prefixIcon: const Icon(
                Icons.lock,
                // color: appThemeData.colorScheme.onPrimary,
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
            child: const Text(AppText.apply),
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
    //TODO Написать метод, который обновляет данные пользователя (имя, город, пароль) в БД
    log(_debug, '[$_ChangePasswordFormState._registerUser] METHOD TO BE IMPLEMENTED !!!');
    // throw Exception('[$_ChangePasswordFormState._registerUser] METHOD TO BE IMPLEMENTED !!!');
    setState(() {
      _isLoading = true;
    });
    RegisterUser(
      remote: dataSource.dataSet<Map<String, dynamic>>('set_client'),
      group: UserGroup.normal,
      location: _userLocation,
      name: _userName,
      phone: _userPhone.number(),
      pass: _userPassword.encrypted(),
    )
      .fetch()
      .then((response) {
        setState(() {
          _isLoading = false;
        });
        if(!response.hasError()) {
          FlushbarHelper.createSuccess(
            duration: AppUiSettings.flushBarDuration,
            message: 'Ваши данные обновлены, сохраните ваш логин и пароль.',
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
