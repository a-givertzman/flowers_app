import 'package:flutter/material.dart';

class SizedProgressIndicator extends StatelessWidget {
  final double _height;
  final double _width;
  const SizedProgressIndicator({
    Key? key,
    required double width,
    required double height,
  }) : 
    _width = width,
    _height = height,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          child: const CircularProgressIndicator(),
          width: _width,
          height: _height,
        ),
    );
  }
}
