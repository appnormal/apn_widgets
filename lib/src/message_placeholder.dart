import 'package:flutter/material.dart';
import 'extensions.dart';

class MessagePlaceholder extends StatelessWidget {
  final String message;

  const MessagePlaceholder({Key key, @required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).accentColor.lighten(0.5),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
