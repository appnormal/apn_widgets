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
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.check, color: Colors.white),
          )
        ],
      ),
    );
  }
}

class _ButtonsPageBody extends StatefulWidget {
  @override
  __ButtonsPageBodyState createState() => __ButtonsPageBodyState();
}

class __ButtonsPageBodyState extends State<_ButtonsPageBody> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 250),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              loading: isLoading,
              title: 'This is a primary button',
              onPressed: () {
                setState(() => isLoading = true);

                Future.delayed(Duration(seconds: 2)).then((value) => setState(() => isLoading = false));
              },
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
      ),
    );
  }
}
