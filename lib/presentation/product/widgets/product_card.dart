import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/remains_widget.dart';
import 'package:flowers_app/presentation/product/widgets/product_image_widget.dart';
import 'package:flowers_app/presentation/product/widgets/set_order_widget.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final PurchaseProduct purchaseProduct;

  const ProductCard({
    Key? key,
    required this.purchaseProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ProductImageWidget(purchaseProduct: purchaseProduct),
              Container(
                width: double.infinity,
                color: appThemeData.colorScheme.secondary,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${purchaseProduct['product/name']}',
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.subtitle2,
                      ),
                      const SizedBox(height: 8,),
                      Text(
                        '${purchaseProduct['product/detales']}',
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.bodyText2,
                      ),
                      const SizedBox(height: 12,),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 12.0,
                                  left: 8.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Цена за шт:   ${purchaseProduct['sale_price']}',
                                      textAlign: TextAlign.left,
                                      style: appThemeData.textTheme.bodyText2,
                                    ),
                                    const SizedBox(height: 24,),
                                    RemainsWidget(
                                      caption: 'Доступно:   ', 
                                      value: '${purchaseProduct['remains']}',
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0,),
                            SetOrderWidget(
                              min: 1,
                              max: int.parse('${purchaseProduct['remains']}'),
                              product: purchaseProduct,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        '${purchaseProduct['product/description']}',
                        textAlign: TextAlign.left,
                        style: appThemeData.textTheme.bodyText2,
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
