import 'package:example/features/shared/example_page.dart';
import 'package:flutter/material.dart';
import 'package:apn_widgets/apn_widgets.dart';

class AnimatedPopupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      child: _AnimatedPopupBody(),
      title: 'Animated popup',
    );
  }
}

class _AnimatedPopupBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        FlatButton(
          child: Text('Show animated popup'),
          onPressed: () => showAnimatedPopup(
            context,
            title: 'This is a title',
            message: 'This is an animated popup',
            backgroundColor: Colors.red,
            animation: 'lib/assets/error_animation.flr',
            animationName: 'Error',
            button: PlatformButton(
              onTap: () => Navigator.of(context).pop(),
              child: Text('Button'),
            ),
          ),
        ),
        SizedBox(height: 10),
        FlatButton(
          child: Text('Show success'),
          onPressed: () => showSuccessPopup(
            context,
            title: 'This is a title',
            message: 'This is an animated popup',
            backgroundColor: Colors.red,
          ),
        ),
        SizedBox(height: 10)
      ]),
    );
  }
}
