import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flowers_app/presentation/product/product_page.dart';
import 'package:flowers_app/presentation/user_account/widgets/order_tile_image_widget.dart';
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
        );        
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
                              // '${order['purchase/name']}',
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              style: appThemeData.textTheme.subtitle2,
                            ),
                            const SizedBox(height: 8,),
                            Text(
                              '${order['product/group']}',
                              // '${order['purchase/details']}',
                              style: appThemeData.textTheme.bodySmall,
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
                        order.remove();
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
                        '${order['count']}x${order['purchase_content/sale_price']}',
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
}
