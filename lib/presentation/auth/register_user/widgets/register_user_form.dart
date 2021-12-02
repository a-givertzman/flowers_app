import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/domain/auth/register_user.dart';
import 'package:flowers_app/domain/auth/user.dart';
import 'package:flowers_app/domain/auth/user_group.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/infrastructure/datasource/data_set.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/In_pogress_overlay.dart';
import 'package:flowers_app/presentation/purchase/purchase_overview/purchase_overview_page.dart';
import 'package:flutter/material.dart';

class RegisterUserForm extends StatefulWidget {
  final User user;
  const RegisterUserForm({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<RegisterUserForm> createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  bool _isLoading = false;
  String _userName = '';
  String _userLocation = '';

  @override
  Widget build(BuildContext context) {
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

  Widget _buildSignInWidget(BuildContext context, AsyncSnapshot<Object?> auth) {
    print('_buildSignInWidget!!!');
    const paddingValue = 13.0;
    return Form(
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
            validator: (value) => null,
            onChanged: (value) {
              _userName = value;
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
            onChanged: (value) {
              _userLocation = value;
            }
          ),
          const SizedBox(height: paddingValue),
          ElevatedButton(
            child: const Text('Готово'),
            onPressed: () {
              RegisterUser(
                remote: dataSource.dataSet('set_client') as DataSet<Map>,
                group: UserGroup.normal,
                location: _userLocation,
                name: _userName,
                phone: widget.user['phone'],
              )
                .fetch()
                .then((response) {
                  Navigator.pop(context, !response.hasError());
                });
            },
          ),
        ],
      ),
    );
  }
}
