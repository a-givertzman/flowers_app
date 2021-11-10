import 'package:flowers_app/assets/settings/product_card_setting.dart';
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
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          value,
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyText2!
            .copyWith(color: ProductCardSetting.remainsColor),
        ),
      ],
    );
  }
}