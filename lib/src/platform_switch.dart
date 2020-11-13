import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PlatformSwitch extends StatelessWidget {
  final Color activeColor;
  final Color trackColor;
  final DragStartBehavior dragStartBehaviour;
  final bool value;
  final ValueChanged<bool> onValueChanged;

  const PlatformSwitch({
    Key key,
    this.value = false,
    this.onValueChanged,
    this.activeColor,
    this.trackColor,
    this.dragStartBehaviour = DragStartBehavior.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onValueChanged,
        activeColor: activeColor,
        trackColor: trackColor,
        dragStartBehavior: dragStartBehaviour,
      );
    }
    //The colors do 't really work for the material switch. That's why we don't use them
    return Switch(
      value: value,
      onChanged: onValueChanged,
      activeColor: activeColor,
      dragStartBehavior: dragStartBehaviour,
    );
  }
}
