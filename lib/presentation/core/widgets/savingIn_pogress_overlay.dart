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
        color: isSaving ? Theme.of(context).colorScheme.primary.withOpacity(0.6) : Colors.transparent,
        child: Visibility(
          visible: isSaving,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onPrimary
                ),
                const SizedBox(height: 8.0,),
                Text(
                  'Загружаю...',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
