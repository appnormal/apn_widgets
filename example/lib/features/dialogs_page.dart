import 'package:apn_widgets/apn_widgets.dart';
import 'package:example/features/shared/example_page.dart';
import 'package:flutter/material.dart';

class DialogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DialogPresenter(
      child: ExamplePage(
        child: _DialogsPageBody(),
        title: 'Dialogs Page',
      ),
    );
  }
}

class _DialogsPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              child: Text('Show alert'),
              onPressed: () => DialogPresenter.of(context).showAlert('Alert title', 'Alert message')),
          TextButton(
              child: Text('Show error'),
              onPressed: () => DialogPresenter.of(context).showError(ErrorResponse.fromMessage('This is an error'))),
          TextButton(
              child: Text('Show open app settings'),
              onPressed: () => DialogPresenter.of(context).showOpenAppSettingsAlert(
                  'We want to open app settings', 'Pretty please let us open the app settings')),
        ],
      ),
    );
  }
}

class ErrorResponse {
  ErrorResponse(this.message);

  final String message;

  factory ErrorResponse.fromMessage(String message) => ErrorResponse(message);

  @override
  String toString() => message;
}
