import 'package:apn_widgets/apn_widgets.dart';
import 'package:example/features/shared/example_page.dart';
import 'package:flutter/material.dart';

class ButtonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      child: _ButtonsPageBody(),
      title: 'Buttons Page',
      appBar: AppBar(
        title: Text('Buttons Page'),
        actions: [
          AppBarAction(
            onTap: () {},
            child: Image.asset(
              'lib/assets/check_mark.png',
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class _ButtonsPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButton(
            title: 'This is a primary button',
            onPressed: () {},
          ),
          SizedBox(
            height: 5,
          ),
          PlatformButton(
            child: Text(
              'This is a platform button',
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
