import 'package:flowers_app/presentation/core/app_theme.dart';
import 'package:flutter/material.dart';

class CountButton extends StatefulWidget {
  final int min;
  final int max;
  final int initialCount;
  final bool disabled;
  final ValueChanged<int>? onChange;
  ///
  ///
  const CountButton({
    super.key,
    required this.min,
    required this.max,
    required this.initialCount,
    this.disabled = false,
    this.onChange,
  });
  //
  //
  @override
  _CountButtonState createState() => _CountButtonState();
}
//
//
class _CountButtonState extends State<CountButton> {
  int count = 0;
  ///
  ///
  void onPress() {
    final onChange = widget.onChange;
    if  (onChange != null) {
      onChange(count);
    }
  }
  //
  //
  @override
  void initState() {
    count = widget.initialCount;
    super.initState();
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    if (widget.min > count) {
      setState(() {
        count = widget.min;
        onPress();
      });
    }
    return widget.disabled
      ? Opacity(
        opacity: 0.5,
        child: AbsorbPointer(child: buildButton()),
      )
      : buildButton();
  }
  ///
  ///
  Widget buildButton() {
    return Row(
      children: [
        IconButton(
          color: appThemeData.colorScheme.onSecondary,
          onPressed: (){
            if (count > widget.min) {
              setState(() {
                count--;                      
                onPress();
              });
            }
          }, 
          icon: const Icon(
            Icons.remove,
          ),
        ),
        const SizedBox(width:  8,),
        Text(
          count.toString(),
          textAlign: TextAlign.left,
          style: appThemeData.textTheme.titleSmall,
        ),
        const SizedBox(width: 8,),
        IconButton(
          color: appThemeData.colorScheme.onSecondary,
          onPressed: () {
            if (count < widget.max) {
              setState(() {
                count++;                      
                onPress();
              });
            }
          }, 
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );    
  }
}
