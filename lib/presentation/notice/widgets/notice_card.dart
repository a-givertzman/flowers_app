import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class NoticeCard extends StatefulWidget {
  final Notice notice;
  const NoticeCard({
    required Key key,
    required this.notice,
  }) : super(key: key);

  @override
  State<NoticeCard> createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  bool _viewed = false;
  @override
  void initState() {
    widget.notice.viewed()
      .then((value) {
        setState(() {
          _viewed = value;
        });
      },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final _messageSent = widget.notice.isSent();
    return VisibilityDetector(
      key: ValueKey(widget.key),
      onVisibilityChanged: (VisibilityInfo info) {
        final _notice = widget.notice;
        if (info.visibleFraction == 1) {
          _notice.setViewed();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: _messageSent ? 16.0 : 0.0,
          right: _messageSent ? 0.0 : 16.0,
          top: 2.0,
          bottom: 2.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _messageSent ? Colors.green[100] : appThemeData.colorScheme.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.notice['message']}',
                      ),
                      const SizedBox(height: 4,),
                      Text(
                        '${widget.notice['updated']}',
                        style: appThemeData.textTheme.caption,
                      ),
                    ],
                  ),
                ),
                if (!_viewed)
                  const Icon(
                    Icons.messenger_outline,
                    color: Colors.blue,
                    size: baseFontSize * 1.3,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
