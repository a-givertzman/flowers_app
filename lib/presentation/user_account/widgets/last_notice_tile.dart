import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class LastNoticeTile extends StatefulWidget {
  final Stream<Notice> noticeStream;
  const LastNoticeTile({
    Key? key,
    required this.noticeStream,
  }) : super(key: key);

  @override
  State<LastNoticeTile> createState() => _LastNoticeTileState();
}

class _LastNoticeTileState extends State<LastNoticeTile> {
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Notice>(
      stream: widget.noticeStream,
      builder: (context, snapshot) {
        final hasError = snapshot.hasError;
        bool viewed = false;
        String message = '';
        if (snapshot.hasError) {
          log('[LastNoticeTile.build] snapshot.hasError:', snapshot.error);
        }
        if (snapshot.hasData) {
          final notice = snapshot.data;
          if (notice != null) {
            message = '${notice['message']}';
            notice
              .viewed()
              .then((value) => viewed = value);
          }
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              hasError
                ? Icons.error_outline
                : Icons.message,
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
      },
    );
  }
}
