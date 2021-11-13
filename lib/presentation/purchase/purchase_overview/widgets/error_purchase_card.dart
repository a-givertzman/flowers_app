import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class ErrorPurchaseCard extends StatelessWidget {
  final String? message;
  const ErrorPurchaseCard({
    Key? key,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: appThemeData.errorColor,
      child: Padding(
        padding: const EdgeInsets.all(CommonUiSettings.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ошибка при загрузке данных,\nобратитесь к оганизаторам',
              style: appThemeData.primaryTextTheme.subtitle1,
            ),
            const SizedBox(height: 4,),
            Text(
              'Технические детали:',
              style: appThemeData.primaryTextTheme.subtitle1,
            ),
            Text(
              message ?? '',
              style: appThemeData.primaryTextTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
