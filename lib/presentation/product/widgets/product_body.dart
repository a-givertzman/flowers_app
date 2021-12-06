import 'package:flowers_app/dev/log/log.dart';
import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/product/widgets/product_card.dart';
import 'package:flutter/material.dart';

class ProductBody extends StatelessWidget {
  final PurchaseProduct purchaseProduct;
  const ProductBody({
    Key? key,
    required this.purchaseProduct,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        log('[ProductBody.build]');
        return ProductCard(
          purchaseProduct: purchaseProduct,
        );
      },
    );
  }
}
