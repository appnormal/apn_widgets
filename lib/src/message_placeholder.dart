import 'package:flutter/material.dart';
import 'extensions.dart';

class MessagePlaceholder extends StatelessWidget {
  final Text child;

  const MessagePlaceholder({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: child
          ),
        ),
      ),
    );
  }
}
