import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class InProgressOverlay extends StatelessWidget {
  final bool isSaving;
  const InProgressOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving 
          ? appThemeData.colorScheme.secondary.withOpacity(0.8) 
          : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  color: appThemeData.colorScheme.onSecondary
                ),
                const SizedBox(height: 8.0,),
                Text(
                  'Загружаю...',
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
