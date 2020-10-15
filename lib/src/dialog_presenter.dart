import 'dart:async';
import 'dart:io';

import 'package:apn_http/apn_http.dart';
import 'package:apn_widgets/apn_widgets.dart';
import 'package:apn_widgets/src/radio_button_dialog.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kStringOK = 'OK';
const kStringAppName = 'NAME';
const kStringAppSettings = 'SETTINGS';

class DialogPresenter extends StatefulWidget {
  static _DialogPresenterState of(BuildContext context) {
    final presenterState = (context.dependOnInheritedWidgetOfExactType<DialogPresenterData>()).data;
    presenterState.callingContext = context;
    return presenterState;
  }

  static void pop<T>(BuildContext context, [T result]) => of(context).popDialog(result);

  const DialogPresenter({Key key, @required this.child, this.strings}) : super(key: key);

  final Widget child;
  final Map<String, String> strings;

  @override
  _DialogPresenterState createState() => _DialogPresenterState();
}

class _DialogPresenterState extends State<DialogPresenter> {
  BuildContext callingContext;
  Map<String, String> strings;

  Dialog activeDialog;
  final queue = <Dialog>[];

  bool get hasStrings => strings != null && strings.isNotEmpty;

  String get appName => hasStrings
      ? strings.containsKey(kStringAppName)
          ? strings[kStringAppName]
          : 'App'
      : 'App';

  String get ok => hasStrings
      ? strings.containsKey(kStringOK)
          ? strings[kStringOK]
          : 'OK'
      : 'OK';

  String get settings => hasStrings
      ? strings.containsKey(kStringAppSettings)
          ? strings[kStringAppSettings]
          : 'Open settings'
      : 'Open settings';

  @override
  void initState() {
    super.initState();
    strings = widget.strings;
  }

  void updateStrings(Map<String, String> stringMap) {
    strings = stringMap;
  }

  @override
  Widget build(BuildContext context) {
    return DialogPresenterData(
      child: widget.child,
      data: this,
    );
  }

  void _presentDialog(Dialog dialog) {
    if (activeDialog != null) {
      activeDialog.completer.complete();
      Navigator.of(callingContext).pop();
    }

    activeDialog = dialog;
    showDialog(context: callingContext, child: dialog.widget);
  }

  void queueError(ErrorResponse error) {
    showAlert(
      appName,
      error.error.message,
      queueDialog: true,
    );
  }

  Future<void> showError(ErrorResponse error) => showAlert(appName, error.error.message);

  void popDialog<T>([T result]) {
    activeDialog.completer.complete(result);
    Navigator.of(callingContext).maybePop();
  }

  Future<T> showAlert<T>(String title, String message, {List<Widget> actions, bool queueDialog = false}) {
    final closeAndShowNextInQueue = () {
      activeDialog = null;
      if (queue.isNotEmpty) {
        _presentDialog(queue.removeAt(0));
      }
    };

    final alert = WillPopScope(
      onWillPop: () async {
        closeAndShowNextInQueue();
        return true;
      },
      child: PlatformAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions ??
            <Widget>[
              PlatformAlertDialogAction(
                child: Text(ok),
                onPressed: () {
                  popDialog();
                  closeAndShowNextInQueue();
                },
              )
            ],
      ),
    );

    final dialog = Dialog<T>(alert);
    if (queueDialog && activeDialog != null) {
      queue.add(dialog);
    } else {
      _presentDialog(dialog);
    }

    return dialog.completer.future;
  }

  void showOpenAppSettingsAlert(String title, String message) {
    showAlert(title, message, actions: <Widget>[
      PlatformAlertDialogAction(
        child: Text(ok),
        onPressed: () {
          popDialog();
        },
      ),
      PlatformAlertDialogAction(
        child: Text(settings),
        isDefaultAction: true,
        onPressed: () {
          AppSettings.openAppSettings();
          popDialog();
        },
      ),
    ]);
  }

  Future<int> showPlatformChoiceDialog(
    List<CupertinoActionSheetAction> cupertinoChoices,
    List<String> materialLabels,
    String title,
    String cancelButtonText,
    String confirmButtonText, {
    Widget cupertinoMessage,
  }) async {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: callingContext,
          builder: (context) {
            return CupertinoActionSheet(
              actions: cupertinoChoices,
              message: cupertinoMessage,
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(callingContext).pop(),
                isDefaultAction: true,
                child: Text(
                  cancelButtonText,
                  style: const TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            );
          });
    } else {
      final choice = await showDialog<int>(
          context: callingContext,
          builder: (dialogContext) {
            return RadioButtonDialog(
                title: title,
                buttonLabels: materialLabels,
                cancelText: cancelButtonText,
                confirmText: confirmButtonText,
                onConfirm: (choice) {
                  Navigator.of(dialogContext).pop(choice);
                });
          });
      return choice;
    }
  }
}

class DialogPresenterData extends InheritedWidget {
  final _DialogPresenterState data;

  DialogPresenterData({
    this.data,
    @required Widget child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false; // Never signal child tree to rebuild
  }
}

class Dialog<T> {
  final completer = Completer<T>();
  Widget widget;

  Dialog(this.widget);
}
