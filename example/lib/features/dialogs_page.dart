import 'package:apn_http/apn_http.dart';
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
          FlatButton(
              child: Text('Show alert'),
              onPressed: () => DialogPresenter.of(context).showAlert('Alert title', 'Alert message')),
          FlatButton(
              child: Text('Show error'),
              onPressed: () => DialogPresenter.of(context).showError(ErrorResponse.fromMessage('This is an error'))),
          FlatButton(
              child: Text('Show open app settings'),
              onPressed: () => DialogPresenter.of(context).showOpenAppSettingsAlert(
                  'We want to open app settings', 'Pretty please let us open the app settings')),
        ],
      ),
    );
  }
}
