import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class CriticalErrorWidget extends StatelessWidget {
  static const _debug = false;
  final String message;
  final Future<dynamic> Function() refresh;
  const CriticalErrorWidget({
    Key? key,
    required this.message,
    required this.refresh,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // это оцентрирует по верикали
        children: <Widget>[
          Text(
            'Ошибка при чтении данных',
            textAlign: TextAlign.center,
            style: appThemeData.textTheme.subtitle2,
          ),
          const SizedBox(height: 4,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: appThemeData.textTheme.bodyText2,
            ),
          ),
          const SizedBox(height: 4,),
          TextButton(
            onPressed: () {
              log(_debug, 'Please Implemente the Sending email on critical error');
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mail),
                const SizedBox(width: 4,),
                Text(
                  'Отправить отчет об ошибке',
                  style: appThemeData.textTheme.subtitle2,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              refresh();
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.refresh),
                const SizedBox(width: 4,),
                Text(
                  'Перезагрузить',
                  style: appThemeData.textTheme.subtitle2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
