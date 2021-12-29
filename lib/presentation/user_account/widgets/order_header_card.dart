import 'package:flowers_app/domain/order/order_header.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class OrderHeaderCard extends StatelessWidget {
  final OrderHeader _orderHeader;
  const OrderHeaderCard({
    Key? key,
    required OrderHeader orderHeader,
  }) : 
    _orderHeader = orderHeader,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: appThemeData.colorScheme.secondaryContainer,
      color: appThemeData.colorScheme.background,
      shadowColor: appThemeData.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 32.0,
          top: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Text(
          _orderHeader.purchaseName,
          style: appThemeData.textTheme.subtitle2!.copyWith(
            color: appThemeData.colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}
