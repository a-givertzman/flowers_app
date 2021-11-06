import 'package:flutter/material.dart';

class CriticalErrorWidget extends StatelessWidget {
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
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 4,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          const SizedBox(height: 4,),
          TextButton(
            onPressed: () {
              print('Please Implemente the Sending email on critical error');
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mail),
                const SizedBox(width: 4,),
                Text(
                  'Отправить отчет об ошибке',
                  style: Theme.of(context).textTheme.subtitle2,
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
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}