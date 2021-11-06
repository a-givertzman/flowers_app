import 'package:flowers_app/assets/settings/common_settings.dart';
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
      color: Theme.of(context).errorColor,
      child: Padding(
        padding: const EdgeInsets.all(CommonUiSettings.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ошибка при загрузке данных,\nобратитесь к оганизаторам',
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
            const SizedBox(height: 4,),
            Text(
              'Технические детали:',
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
            Text(
              message ?? '',
              style: Theme.of(context).primaryTextTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}
