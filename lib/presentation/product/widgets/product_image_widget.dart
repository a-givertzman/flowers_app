import 'package:flower_app/presentation/core/widgets/image_on_network.dart';
import 'package:flutter/material.dart';
///
/// Shows Picture in the ProductCard / PurchaseContentCard
class ProductImageWidget extends StatelessWidget {
  final String url;
  ///
  /// - [url] - the link to the image to be loaded
  const ProductImageWidget({
    super.key,
    required this.url,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: ImageOnNetwork(
        url: url,
        placeholder: 'assets/img/product-placeholder.jpg',
      ),
    );
  }
}
