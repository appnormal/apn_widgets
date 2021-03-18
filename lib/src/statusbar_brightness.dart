import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum IconColor { WHITE, BLACK }

class StatusbarColor extends StatelessWidget {
  final Widget child;
  final IconColor? iconColor;

  const StatusbarColor({
    Key? key,
    required this.child,
    this.iconColor = IconColor.WHITE,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: iconColor == IconColor.BLACK ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: child,
    );
  }
}
