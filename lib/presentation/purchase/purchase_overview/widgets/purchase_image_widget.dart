import 'package:flowers_app/presentation/core/widgets/image_on_network.dart';
import 'package:flutter/material.dart';

class PurchaseImageWidget extends StatelessWidget {
  const PurchaseImageWidget({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;
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
