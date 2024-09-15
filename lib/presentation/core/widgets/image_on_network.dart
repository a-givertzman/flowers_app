import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
/// Picture loaded from the internet
class ImageOnNetwork extends StatelessWidget {
  static const _log = Log('ImageOnNetwork');
  final String url;
  final double? height;
  final double? width;
  final String placeholder;
  final double progressIndicatorSize;
  ///
  ///
  const ImageOnNetwork({
    super.key,
    required this.url,
    required this.placeholder,
    this.progressIndicatorSize = 30.0,
    this.height,
    this.width,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    return url.isNotEmpty && validateUrl(url)
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
  ///
  /// Validating url
  bool validateUrl(String url) {
    try {
      return Uri.parse(url).isAbsolute;
    } catch (err) {
      _log.warning('.build | Invalid url: "$url"');
      return false;
    }

  }
}
