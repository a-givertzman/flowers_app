import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flutter/material.dart';

class ImageOnNetwork extends StatelessWidget {
  const ImageOnNetwork({
    Key? key,
    required this.url,
    required this.placeholder,
    this.progressIndicatorSize = 30.0,
    this.height,
    this.width,
  }) : super(key: key);
  final String url;
  final double? height;
  final double? width;
  final String placeholder;
  final double progressIndicatorSize;
  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty
      ? Image.network(
          url,
          height: height,
          width: width,
          loadingBuilder:(context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return SizedProgressIndicator(
              width: progressIndicatorSize,
              height: progressIndicatorSize,
            );
          },
          errorBuilder:(context, error, stackTrace) => Image(
            image: AssetImage(placeholder),
            fit: BoxFit.cover,
          ),
          fit: BoxFit.cover,
        )
      : Image(
        image: AssetImage(placeholder),
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
  }
}
