import 'package:flower_app/domain/order/order_header.dart';
import 'package:flower_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';
///
/// Displays a total by customer's orders
/// in the customer's profile
class OrderHeaderCard extends StatelessWidget {
  final OrderHeader orderHeader;
  const OrderHeaderCard({
    super.key,
    required this.orderHeader,
  });
  //
  @override
  Widget build(BuildContext context) {
    return Card(
      // color: appThemeData.colorScheme.secondaryContainer,
      color: appThemeData.colorScheme.surface,
      shadowColor: appThemeData.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 32.0,
          top: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                orderHeader.purchaseName,
                style: appThemeData.textTheme.titleSmall!.copyWith(
                  color: appThemeData.colorScheme.onSurface,
                ),
              ),
            ),
            Tooltip(
              message: """Общая сумма за все заказы в данной закупке ${orderHeader.total.toStringAsFixed(2)} ${orderHeader.currency},
                          суммарная стоимость товаров ${orderHeader.totalPrice.toStringAsFixed(2)} ${orderHeader.currency},
                          суммарная стоимость доставки ${orderHeader.totalShipping.toStringAsFixed(2)} ${orderHeader.currency}""",
              child: Column(
                children: [
                  Text(
                    '${orderHeader.total.toStringAsFixed(2)} ${orderHeader.currency}',
                    style: appThemeData.textTheme.titleSmall!.copyWith(
                      color: appThemeData.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(${orderHeader.totalPrice.toStringAsFixed(2)} + ${orderHeader.totalShipping.toStringAsFixed(2)})',
                    // style: appThemeData.textTheme.titleSmall!.copyWith(
                    //   color: appThemeData.colorScheme.onSurface,
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
