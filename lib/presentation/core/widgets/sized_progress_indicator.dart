import 'package:flower_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';
///
/// CircularProgressIndicator wrapped into SizedBox
class SizedProgressIndicator extends StatelessWidget {
  final double _height;
  final double _width;
  final Color? _color;
  ///
  ///
  const SizedProgressIndicator({
    super.key,
    required double width,
    required double height,
    Color? color,
  }) : 
    _width = width,
    _height = height,
    _color = color;
  //
  //
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: _width,
          height: _height,
          child: CircularProgressIndicator(
            color: _color ?? appThemeData.colorScheme.onSurface,
          ),
        ),
    );
  }
}
