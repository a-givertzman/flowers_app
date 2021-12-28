import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  const OrderCard({
    Key? key,
    required this.order,
  }) : super(key: key);
  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isLoading = true;
  late Order _order;
  @override
  void initState() {
    _isLoading = false;
    _order = widget.order;
    // refreshPurchaseProduct();
    super.initState();
  }
  // void refreshPurchaseProduct() {
  //   _order
  //     .fetch()
  //     .then((order) {
  //       setState(() {
  //         _order = order as Order;
  //         _isLoading = false;
  //       });
  //     });
  // }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedProgressIndicator(
        height: 40.0,
        width: 40.0,
      );
    } else {
      return _buildOrderTile(_order);
    }
  }
  Widget _buildOrderTile(Order order) {
    return Card(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ProductImageWidget(purchaseProduct: order),
              SizedBox(
              width: double.infinity,
              // color: appThemeData.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${order['product/name']}',
                            // '${order['purchase/name']}',
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: appThemeData.textTheme.subtitle2,
                          ),
                          const SizedBox(height: 8,),
                          Text(
                            '${order['product/group']}',
                            // '${order['purchase/details']}',
                            style: appThemeData.textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${order['cost']}',
                          style: appThemeData.textTheme.subtitle2,
                        ),
                        const SizedBox(height: 8,),
                        Text(
                          '${order['count']}x${order['purchase_content/sale_price']}',
                          style: appThemeData.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            ],
          ),
        ),
      ),
    );
  }
}


            // SizedBox(
            //     width: double.infinity,
            //     // color: appThemeData.colorScheme.secondary,
            //     child: Padding(
            //       padding: const EdgeInsets.all(16.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             '${order['product/name']}',
            //             textAlign: TextAlign.left,
            //             style: appThemeData.textTheme.subtitle2,
            //           ),
            //           const SizedBox(height: 8,),
            //           Text(
            //             '${order['product/group']}',
            //             textAlign: TextAlign.left,
            //             style: appThemeData.textTheme.bodyText2,
            //           ),
            //           const SizedBox(height: 8,),
            //           Padding(
            //             padding: const EdgeInsets.only(
            //               right: 8.0,
            //             ),
            //             child: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //               children: [
            //                 Expanded(
            //                   child: Padding(
            //                     padding: const EdgeInsets.only(
            //                       top: 1.0,
            //                       left: 8.0,
            //                     ),
            //                     child: Column(
            //                       mainAxisSize: MainAxisSize.min,
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           'Стоимость:   ${order['cost']} (${order['purchase_content/sale_price']} x ${order['count']})',
            //                           textAlign: TextAlign.left,
            //                           style: appThemeData.textTheme.bodyText2,
            //                         ),
            //                         const SizedBox(height: 4,),
            //                         RemainsWidget(
            //                           caption: 'Размещен: ', 
            //                           value: '${order['updated']}',
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(width: 8.0,),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),