import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class SizedProgressIndicator extends StatelessWidget {
  final double _height;
  final double _width;
  final Color? _color;
  const SizedProgressIndicator({
    Key? key,
    required double width,
    required double height,
    Color? color,
  }) : 
    _width = width,
    _height = height,
    _color = color,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          child: CircularProgressIndicator(
            color: _color ?? appThemeData.colorScheme.onBackground,
          ),
          width: _width,
          height: _height,
        ),
    );
  }
}
