import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PlatformSwitch extends StatelessWidget {
  final Color activeColor;
  final Color activeTrackColor;
  final Color inactiveTrackColor;
  final Color activeThumbColor;
  final Color inactiveThumbColor;

  final DragStartBehavior dragStartBehaviour;
  final bool value;
  final ValueChanged<bool> onValueChanged;

  const PlatformSwitch({
    Key key,
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
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onValueChanged,
        activeColor: activeColor,
        trackColor: value ? activeTrackColor : inactiveTrackColor,
        dragStartBehavior: dragStartBehaviour,
      );
    }

    return Theme(
      data: ThemeData(accentColor: activeThumbColor),
      child: Switch(
        value: value,
        onChanged: onValueChanged,
        activeColor: activeColor,
        dragStartBehavior: dragStartBehaviour,
        activeTrackColor: activeTrackColor.withOpacity(0.6),
        inactiveThumbColor: inactiveThumbColor,
        inactiveTrackColor: inactiveTrackColor.withOpacity(0.6),
      ),
    );
  }
}
