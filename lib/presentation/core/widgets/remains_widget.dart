import 'package:flowers_app/assets/settings/product_card_setting.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class RemainsWidget extends StatelessWidget {
  final String caption;
  final String value;
  const RemainsWidget({
    Key? key,
    required this.caption,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          caption,
          textAlign: TextAlign.left,
          style: appThemeData.textTheme.bodyText2,
        ),
        Text(
          value,
          textAlign: TextAlign.left,
          style: appThemeData.textTheme.bodyText2!
            .copyWith(color: ProductCardSetting.remainsColor),
        ),
      ],
    );
  }
}