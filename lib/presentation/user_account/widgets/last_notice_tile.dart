import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class LastNoticeTile extends StatefulWidget {
  final Future<Notice> lastNotice;
  const LastNoticeTile({
    Key? key,
    required this.lastNotice,
  }) : super(key: key);

  @override
  State<LastNoticeTile> createState() => _LastNoticeTileState();
}

class _LastNoticeTileState extends State<LastNoticeTile> {
  bool hasError = false;
  bool viewed = true;
  final noMessages = 'сообщений нет';
  String message = '';
  @override
  Widget build(BuildContext context) {
    widget.lastNotice
      .then((_notice) {
        log('[$_LastNoticeTileState.build] notice: ', _notice);
        final newMessage = '${_notice['message']}' == '' 
          ? noMessages 
          : '${_notice['message']}';
        if (message != newMessage) {
          setState(() {          
            message = newMessage;
          });
        }
        _notice
          .viewed()
          .then((value) {
            if (viewed != value) {
              setState(() {
                viewed = value;  
              });
            }
          });
      })
      .onError((error, stackTrace) {
          log('[$_LastNoticeTileState.build] error: ', error);
          setState(() {
            hasError = true;
          });
      });

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              hasError
                ? Icons.error_outline
                : message == noMessages
                  ? Icons.messenger_outline
                  : Icons.message_outlined,
              size: baseFontSize * 1.3,
              color: hasError
              ? appThemeData.errorColor 
              : viewed
                ? Colors.grey
                : Colors.blue,
            ),
            const SizedBox(width: 4.0,),
            Expanded(
              child: Text(
                message,
                // 'Последнее сообщение по данной позиции. Последнее сообщение по данной позиции. Последнее сообщение по данной позиции.',
                style: appThemeData.textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
  }
}
