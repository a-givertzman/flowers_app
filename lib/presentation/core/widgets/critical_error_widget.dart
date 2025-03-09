import 'package:flower_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
///
class CriticalErrorWidget extends StatelessWidget {
  static const _log = Log('CriticalErrorWidget');
  final String message;
  final Future<dynamic> Function() refresh;
  const CriticalErrorWidget({
    super.key,
    required this.message,
    required this.refresh,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    _log.debug('.build | ');
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min, // это оцентрирует по верикали
        children: <Widget>[
          Text(
            'Ошибка при чтении данных',
            textAlign: TextAlign.center,
            style: appThemeData.textTheme.titleSmall,
          ),
          const SizedBox(height: 4,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: appThemeData.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 4,),
          TextButton(
            onPressed: () {
              _log.warning('.build | Please Implemente the Sending email on critical error');
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mail),
                const SizedBox(width: 4,),
                Text(
                  'Отправить отчет об ошибке',
                  style: appThemeData.textTheme.titleSmall,
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
                  style: appThemeData.textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
