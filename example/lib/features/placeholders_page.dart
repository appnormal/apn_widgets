import 'package:apn_widgets/apn_widgets.dart';
import 'package:example/features/shared/example_page.dart';
import 'package:flutter/material.dart';

class PlaceholdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      child: _PlaceholdersPageBody(),
      title: 'Placeholders page',
    );
  }
}

class _PlaceholdersPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MessagePlaceholder(
            child: Text(
              'This is a placeholder',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
        ),
        PlatformLoader()
      ],
    );
  }
}
