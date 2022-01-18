import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
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
      child: Image.network(
        url,
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
