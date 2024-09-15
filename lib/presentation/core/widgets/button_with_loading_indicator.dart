import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
///
///
class ButtonWithLoadingIndicator extends StatefulWidget {
  final double _width;
  final double _height;
  final Widget child;
  ///
  ///
  const ButtonWithLoadingIndicator({
    super.key,
    required this.child,
    double? width,
    double? height,
    required this.onSubmit,
  }):
    _width = width ?? 110.0,
    _height = height ?? 32.0;

  final Future<Result<Map<String, dynamic>, Failure>> Function() onSubmit;
  //
  //
  @override
  State<ButtonWithLoadingIndicator> createState() => _ButtonWithLoadingIndicatorState();
}
//
//
class _ButtonWithLoadingIndicatorState extends State<ButtonWithLoadingIndicator> {
  bool _isLoading = false;
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final _size = widget._height < widget._width
      ? widget._height * 0.75
      : widget._width * 0.75;
    return RepaintBoundary(
      child: SizedBox(
        width: widget._width,
        height: widget._height,
        child: _isLoading
          ? Center(
            child: SizedProgressIndicator(
              height: _size,
              width: _size,
            ),
          )
          : TextButton(
            child: widget.child,
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              widget.onSubmit().then((response) {
                setState(() {
                  _isLoading = false;
                });
              });
            },
          ),
      ),
    );
  }
}
