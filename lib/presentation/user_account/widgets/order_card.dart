import 'package:flowers_app/domain/order/order.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/infrastructure/datasource/app_data_source.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
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
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) =>  ProductPage(
              product: _product,
              dataSource: dataSource,
            ),
          ),
        );        
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ProductImageWidget(purchaseProduct: order),
            SizedBox(
            width: double.infinity,
            // color: appThemeData.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrderTileImageWidget(
                    url: '${order['product/picture']}',
                    radius: 32.0,
                  ),
                  const SizedBox(width: 8.0,),
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
                          style: appThemeData.textTheme.bodySmall,
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
    );
  }
}
