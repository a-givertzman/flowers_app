import 'package:flowers_app/infrastructure/api/response.dart';
import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flowers_app/presentation/core/widgets/sized_progress_indicator.dart';
import 'package:flutter/material.dart';

class ButtonWithLoadingIndicator extends StatefulWidget {
  final double width;
  final double height;
  const ButtonWithLoadingIndicator({
    Key? key,
    this.width = 110.0,
    this.height = 32.0,
    required this.onSubmit,
  }) : super(key: key);

  final Future<Response> Function() onSubmit;

  @override
  State<ButtonWithLoadingIndicator> createState() => _ButtonWithLoadingIndicatorState();
}

class _ButtonWithLoadingIndicatorState extends State<ButtonWithLoadingIndicator> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _size = widget.height < widget.width
      ? widget.height * 0.75
      : widget.width * 0.75;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _isLoading
        ? Center(
          child: SizedProgressIndicator(
            height: _size,
            width: _size,
          ),
        )
        : TextButton(
          child: const Text('Применить'),
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
    );
  }
}