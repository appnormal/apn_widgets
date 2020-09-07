import 'package:apn_widgets/apn_widgets.dart';
import 'package:example/features/shared/example_page.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      child: _SearchPageBody(),
      title: 'Search page',
    );
  }
}

class _SearchPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Center(
      child: SearchBar(
        onSearchCleared: () => {},
        onFieldSubmitted: (String value) => {},
        controller: controller,
      ),
    );
  }
}
