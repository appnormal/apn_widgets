import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PlatformSwitch extends StatelessWidget {
  final Color? activeColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeThumbColor;
  final Color? inactiveThumbColor;

  final DragStartBehavior dragStartBehaviour;
  final bool value;
  final ValueChanged<bool>? onValueChanged;

  const PlatformSwitch({
    Key? key,
    this.value = false,
    this.onValueChanged,
    this.activeColor,
    this.dragStartBehaviour = DragStartBehavior.start,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeThumbColor,
    this.inactiveThumbColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onValueChanged,
        activeColor: activeColor,
        trackColor: value ? activeTrackColor : inactiveTrackColor,
        dragStartBehavior: dragStartBehaviour,
      );
    }

    return Theme(
      data: ThemeData(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: activeThumbColor)),
      child: Switch(
        value: value,
        onChanged: onValueChanged,
        activeColor: activeColor,
        dragStartBehavior: dragStartBehaviour,
        activeTrackColor: activeTrackColor!.withOpacity(0.6),
        inactiveThumbColor: inactiveThumbColor,
        inactiveTrackColor: inactiveTrackColor!.withOpacity(0.6),
      ),
    );
  }
}
