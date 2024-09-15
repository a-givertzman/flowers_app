import 'package:flowers_app/assets/settings/common_settings.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';
///
///
class ErrorPurchaseCard extends StatelessWidget {
  final String? message;
  ///
  ///
  const ErrorPurchaseCard({
    super.key,
    this.message,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return Card(
      color: appThemeData.colorScheme.error,
      child: Padding(
        padding: const EdgeInsets.all(AppUiSettings.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ошибка при загрузке данных,\nобратитесь к оганизаторам',
              style: appThemeData.textTheme.titleMedium,
            ),
            const SizedBox(height: 4,),
            Text(
              'Технические детали:',
              style: appThemeData.textTheme.titleMedium,
            ),
            Text(
              message ?? '',
              style: appThemeData.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
