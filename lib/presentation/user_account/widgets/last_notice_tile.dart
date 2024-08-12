import 'package:flowers_app/assets/texts/app_text.dart';
import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
///
///
class LastNoticeTile extends StatefulWidget {
  final Future<Notice> lastNotice;
  final Future<bool> hasNotRead;
  ///
  ///
  const LastNoticeTile({
    required Key key,
    required this.lastNotice,
    required this.hasNotRead,
  }) : super(key: key);
  //
  //
  @override
  State<LastNoticeTile> createState() => _LastNoticeTileState();
}
//
//
class _LastNoticeTileState extends State<LastNoticeTile> {
  static const _debug = false;
  bool _hasError = false;
  bool _hasNotRead = true;
  String _message = '';
  Notice? _notice;
  @override
  void initState() {
    super.initState();
    widget.lastNotice
      .then((notice) {
        _notice = notice;
        log(_debug, '[$_LastNoticeTileState.initState] lastNotice: ', notice);
        final newMessage = notice.message == '' 
          ? AppText.noNotines 
          : notice.message;
        if (_message != newMessage && mounted) {
          setState(() {          
            _message = newMessage;
          });
        }
      })
      .onError((error, stackTrace) {
          log(_debug, '[$_LastNoticeTileState.initState] lastNotice error: ', error);
          if (mounted) {
            setState(() {
              _hasError = true;
            });
          }
      });
    widget.hasNotRead
      .then((value) {
        if (_hasNotRead != value && mounted) {
          setState(() {
            _hasNotRead = value;
          });
        }
      })
      .onError((error, stackTrace) {
          log(_debug, '[$_LastNoticeTileState.initState] notRead error: ', error);
          if (mounted) {
            setState(() {
              _hasError = true;
            });
          }
      });
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.key),
      onVisibilityChanged: (VisibilityInfo info) {
        final notice = _notice;
        if (info.visibleFraction == 1) {
          if (notice != null) {
            // _notice.setViewed();
          }
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _hasError
              ? Icons.error_outline
              : _message == AppText.noNotines
                ? Icons.messenger_outline
                : Icons.message_outlined,
            size: baseFontSize * 1.3,
            color: _hasError
            ? appThemeData.colorScheme.error 
            : _hasNotRead
              ? Colors.blue
              : Colors.grey,
          ),
          const SizedBox(width: 4.0,),
          Expanded(
            child: Text(
              _message,
              // 'Последнее сообщение по данной позиции.',
              style: appThemeData.textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
