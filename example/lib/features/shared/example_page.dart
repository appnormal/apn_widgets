import 'package:flutter/material.dart';

class ExamplePage extends StatelessWidget {
  final String title;
  final Widget child;
  final PreferredSizeWidget? appBar;

  const ExamplePage({
    Key? key,
    required this.title,
    required this.child,
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
