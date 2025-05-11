import 'package:flower_app/domain/notice/notice.dart';
import 'package:flutter/material.dart';

///
///
Widget buildNoticeIcon({
  required BuildContext context,
  required Notice? notice,
  required bool hasError,
  required bool hasNotRead,
  Color? errorColor,
  double? size,
}) {
  return Icon(
    hasError || notice == null
      ? Icons.error_outline
      : notice.isEmpty
        ? Icons.messenger_outline
        : Icons.message_outlined,
    size: size,
    color: hasError
      ? errorColor ?? Theme.of(context).colorScheme.error 
      : hasNotRead
        ? Colors.blue
        : Colors.grey,
  );
}
