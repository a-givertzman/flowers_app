import 'package:flowers_app/presentation/core/widgets/image_on_network.dart';
import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flutter/material.dart';

class OrderTileImageWidget extends StatelessWidget {
  const OrderTileImageWidget({
    Key? key,
    required this.url,
    required this.radius,
  }) : super(key: key);

  final String url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(122, 0, 0, 0),
            blurRadius: 0.5,
            offset: Offset(0, 0.5),
            spreadRadius: 0.2,
          ),
        ],
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(radius),
        child: ImageOnNetwork(
          url: url, 
          height: radius * 2,
          width: radius * 2,
          placeholder: 'assets/img/product-placeholder.jpg',
          progressIndicatorSize: radius * 0.64,
        ),
      ),
    );
  }
}
