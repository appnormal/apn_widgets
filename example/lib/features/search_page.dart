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
      child: Column(children: [
        SearchBar(
          onSearchCleared: () => {},
          onFieldSubmitted: (String value) => {},
          controller: controller,
        ),

        SizedBox(height: 50),

        SearchBar(
          onSearchCleared: () => {},
          onFieldSubmitted: (String value) => {},
          controller: controller,
          prefixIconColor: Colors.white,
          suffixIconColor: Colors.white,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.red]
            )
          ),
        ),
      ]),
    );
  }
}
