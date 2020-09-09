import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget appBar;

  const ExamplePage({
    Key key,
    this.title,
    this.child,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(title: Text(title)),
      body: child,
    );
  }
}
