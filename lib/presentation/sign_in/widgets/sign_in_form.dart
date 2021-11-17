import 'dart:convert';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/domain/user/user.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    Key? key,
    // required this.user,
  }) : super(key: key);
  // final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: user.authStream,
      builder:(context, auth) {
        return _buildSignInWidget(context);
      },
    );
  }

  Widget _buildSignInWidget(BuildContext context) {
    const paddingValue = 16.0;
    String userPhone = '';
    SharedPreferences.getInstance()
      .then((value) {
        final spwd = value.getString('spwd');
        if (spwd != null) {
          userPhone = decodeStr(spwd);
          print('stored userPhone: $userPhone');
          _loadUser(context, userPhone);
        }
      });
    return Form(
      // autovalidateMode: user.showErrorMessages,
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
            initialValue: userPhone,
            onChanged: (value) {
              userPhone = value;
              //TODO Implemente Номер телефона changed
            }
          ),
          const SizedBox(height: paddingValue),
          TextButton(                                                   // Sign In Button
            child: const Text('Отпраить код'),
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
              _loadUser(context, userPhone);
            },
          ),
          // if(user.isRequesting) ...[
          //   const SizedBox(height: paddingValue,),
          //   const LinearProgressIndicator(),
          // ],
        ],
      ),
    );
  }
  void _loadUser(BuildContext context, String userPhone) {
              final user = User(
                id: '0',
                remote: dataSource.dataSet('client'),
              );
              user.fetch(params: {
                'where': [{'operator': 'where', 'field': 'phone', 'cond': '=', 'value': userPhone}],
              }).then((user) {
                print('user: $user');
                print("user name: `${user['name']}`");
                print("user account: `${user['account']}`");
                if ('${user["name"]}' != '') {
                  SharedPreferences.getInstance()
                    .then((value) => 
                      value.setString('spwd', encodeStr(userPhone)),
                    );
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) =>  PurchaseOverviewPage(
                        user: user,
                        dataSource: dataSource,
                      ),
                    )              
                  );
                } else {
                  FlushbarHelper.createError(
                    // duration: flushBarDuration,
                    message: 'Такого пользователя нет в системе.',
                  ).show(context);
                }
              })
              .catchError((e) {
                FlushbarHelper.createError(
                  // duration: flushBarDuration,
                  message: 'Не удалось авторизоваться, \nОшибка: ${e.toString()}',
                ).show(context);
              });    
  }
}

String encodeStr(String value) {
  final bytes = utf8.encode(value);
  final base64Str = base64.encode(bytes);
  print('[encodeStr] base64Str: $base64Str');
  return base64Str;
}
String decodeStr(String value) {
  final b64 = base64.decode(value);
  final str = utf8.decode(b64);
  print('[decodeStr] str: $str');
  return str;
}