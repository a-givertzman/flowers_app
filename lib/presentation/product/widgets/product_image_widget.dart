import 'package:flowers_app/domain/purchase/purchase_product.dart';
import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flutter/material.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({
    Key? key,
    required this.purchaseProduct,
  }) : super(key: key);

  final PurchaseProduct purchaseProduct;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Image.network(
        '${purchaseProduct['product/picture']}',
        loadingBuilder:(context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const SizedProgressIndicator(
            width: 30.0,
            height: 30.0,
          );
        },
        errorBuilder:(context, error, stackTrace) => const Image(
          image: AssetImage('assets/img/product-placeholder.jpg'),
          fit: BoxFit.cover,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}

