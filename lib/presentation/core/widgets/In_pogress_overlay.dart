import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class InProgressOverlay extends StatelessWidget {
  final bool _isSaving;
  final String _message;
  const InProgressOverlay({
    Key? key,
    required bool isSaving,
    required String message,
  }) :
    _isSaving = isSaving,
    _message = message,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !_isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: _isSaving 
          ? appThemeData.colorScheme.secondary.withOpacity(0.8) 
          : Colors.transparent,
        child: Visibility(
          visible: _isSaving,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  color: appThemeData.colorScheme.onSecondary,
                ),
                const SizedBox(height: 8.0,),
                Text(
                  _message,
                  style: appThemeData.textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
