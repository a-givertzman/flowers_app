import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/notice/notice.dart';
import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/dialogs/complete_dialog.dart';
import 'package:flowers_app/presentation/core/dialogs/failure_dialog.dart';
import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flowers_app/presentation/product/product_page.dart';
import 'package:flowers_app/presentation/user_account/widgets/last_notice_tile.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_tile_image_widget.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatefulWidget {
  final Order order;
  final Future<Notice> lastNotice;
  const OrderCard({
    Key? key,
    required this.order,
    required this.lastNotice,
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
    return InkWell(
      onTap: () {
        final _product = PurchaseProduct(
          userId: '${order['client/id']}',
          purchaseContentId: '${order['purchase_content/id']}',
          remote: dataSource.dataSet('purchase_product'),
        );
        _product['product/name'] = order['product/name'];
        _product['purchase/id'] = order['purchase/id'];
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>  ProductPage(
              product: _product,
              dataSource: dataSource,
            ),
            settings: const RouteSettings(name: "/productPage"),
          ),
        ).then((_) {
          setState(() {
            _isLoading = true;
            order.fetch(params: {
              'where': [{'operator': 'where', 'field': 'id', 'cond': '=', 'value': '${order['id']}'}],
            },)
              .then((response) {
                setState(() {
                  _isLoading = false;
                });
              });
          });
        });        
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: IntrinsicHeight(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 24.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: OrderTileImageWidget(
                          url: '${order['product/picture']}',
                          radius: 36.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0,),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0, 
                          top: 12.0,
                          right: 4.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${order['product/name']}',
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: appThemeData.textTheme.subtitle2,
                            ),
                            const SizedBox(height: 8.0,),
                            Text(
                              '${order['product/group']}',
                              style: appThemeData.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12.0,),
                            LastNoticeTile(
                              lastNotice: widget.lastNotice,
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      iconSize: 18.0,
                      splashRadius: 20.0,
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _removeOrder(context, order);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 4.0,
                left: 8.0,
                right: 8.0,
                bottom: 16.0,
              ),
              child: Column(
                children: [
                  Text(
                        '${order['cost']}',
                        style: appThemeData.textTheme.subtitle2,
                  ),
                  const SizedBox(height: 8,),
                  Text(
                        '${order['count']}x(${order['purchase_content/sale_price']} + ${order['purchase_content/shipping']})',
                        style: appThemeData.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _removeOrder(
    BuildContext context, 
    Order order,
  ) {
    log('[$_OrderCardState._removeOrder] loading...');
    order.remove()
      .then((response) {
        if (response.hasError()) {
          log('[$_OrderCardState._removeOrder] response.error: ', response.errorMessage());
          showFailureDialog(
            context,
            title: const Text('Ошибка'),
            content: Text('''
  В процессе удаления заказа возникла ошибка: ${response.errorMessage()}
  \nПроверьте интернет соединение или nопробуйте позже.
  \nПриносим извинения за неудобства.''',
              maxLines: 20,
              overflow: TextOverflow.clip,
            ),
          );
        } else if (response.hasData()) {
          showCompleteDialog(
            context,
            title: const Text('Удаление заказа'),
            content: const Text(
              'Заказ успешно удален.',
              maxLines: 20,
              overflow: TextOverflow.clip,
            ),
          );
        }
        return response;
      });
  }
}
