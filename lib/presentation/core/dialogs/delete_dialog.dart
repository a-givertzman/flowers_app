import 'package:flutter/material.dart';

Future<bool?> showDeleteDialog(BuildContext context, Widget content) {
  return showDialog<bool>(
    context: context, 
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Удалить заказ?'),
        content: content,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, false), 
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Удалить'),
          ),
        ],
      );
    },
  );
}
