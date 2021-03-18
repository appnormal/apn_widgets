import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformAlertDialog extends StatelessWidget {
  final Text title;
  final Text content;
  final List<Widget> actions;

  const PlatformAlertDialog({Key? key, required this.title, required this.content, required this.actions})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        title: title,
        content: content,
        actions: actions,
      );
    }
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
    );
  }
}

class PlatformAlertDialogAction extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isDestructiveAction;
  final bool isDefaultAction;

  const PlatformAlertDialogAction({
    Key? key,
    required this.child,
    required this.onPressed,
    this.isDestructiveAction = false,
    this.isDefaultAction = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoDialogAction(
        child: child,
        onPressed: onPressed,
        isDestructiveAction: isDestructiveAction,
        isDefaultAction: isDefaultAction,
      );
    } else {
      return TextButton(
        child: child,
        onPressed: onPressed,
      );
    }
  }
}
