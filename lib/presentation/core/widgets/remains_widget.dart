import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class RemainsWidget extends StatelessWidget {
  final String _caption;
  final String _value;
  const RemainsWidget({
    Key? key,
    required String caption,
    required String value,
  }) : 
    _caption = caption,
    _value = value,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          // fit: FlexFit.loose,
          child: Text(
            _caption,
            textAlign: TextAlign.left,
            style: appThemeData.textTheme.bodyText2,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        Text(
          _value,
          textAlign: TextAlign.left,
          style: appThemeData.textTheme.bodyText2,
        ),
      ],
    );
  }
}
