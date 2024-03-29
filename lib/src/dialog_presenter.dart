import 'dart:async';
import 'dart:io' if (kIsWeb) 'dart:html';

import 'package:apn_widgets/apn_widgets.dart';
import 'package:apn_widgets/src/ios_date_time_picker.dart';
import 'package:apn_widgets/src/radio_button_dialog.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

const kStringOK = 'OK';
const kStringAppName = 'NAME';
const kStringAppSettings = 'SETTINGS';
const kStringCancel = 'CANCEL';
const kStringConfirm = 'CONFIRM';

class DialogPresenter extends StatefulWidget {
  static _DialogPresenterState of(BuildContext context) {
    final presenterState = context.dependOnInheritedWidgetOfExactType<DialogPresenterData>()!.data!;
    presenterState.callingContext = context;
    return presenterState;
  }

  static void pop<T>(BuildContext context, [T? result]) => of(context).popDialog(result);

  const DialogPresenter({Key? key, required this.child, this.strings}) : super(key: key);

  final Widget child;
  final Map<String, String>? strings;

  @override
  _DialogPresenterState createState() => _DialogPresenterState();
}

class _DialogPresenterState extends State<DialogPresenter> {
  late BuildContext callingContext;
  late Map<String, String> strings;

  String get appName => strings[kStringAppName] ?? 'App';
  String get ok => strings[kStringOK] ?? 'OK';
  String get settings => strings[kStringAppSettings] ?? 'Open settings';
  String get cancel => strings[kStringCancel] ?? 'Cancel';
  String get confirm => strings[kStringConfirm] ?? 'Confirm';

  @override
  void initState() {
    super.initState();
    strings = widget.strings ?? {};
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
    showDialog(context: callingContext, builder: (_) => dialog.widget)
        .then((value) => dialog.completer.complete(value));
  }

  Future<void> showError(Object error) => showAlert(appName, error.toString());

  void popDialog<T>([T? result]) {
    final canPop = Navigator.of(callingContext).canPop();
    if (canPop) {
      Navigator.of(callingContext).pop(result);
    }
  }

  Future<T?> showAlert<T>(String title, String message, {List<Widget>? actions}) {
    final alert = PlatformAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: actions ??
          <Widget>[
            PlatformAlertDialogAction(
              child: Text(ok),
              onPressed: () {
                popDialog();
              },
            )
          ],
    );

    final dialog = Dialog<T?>(alert);

    _presentDialog(dialog);

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
    List<PlatformChoiceAction> actions,
    String title,
    String? cancelButtonText,
    String? confirmButtonText, {
    Widget? message,
  }) {
    final completer = Completer<int>();

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      final cupertinoChoices = <CupertinoDialogAction>[];
      var index = 0;

      for (final action in actions) {
        final choiceIndex = index++;
        cupertinoChoices.add(CupertinoDialogAction(
          child: Text(action.text),
          isDefaultAction: action.isDefaultAction,
          isDestructiveAction: action.isDestructiveAction,
          onPressed: () {
            Navigator.of(callingContext).pop();
            completer.complete(choiceIndex);
          },
        ));
      }

      showCupertinoModalPopup(
          context: callingContext,
          builder: (context) {
            return CupertinoActionSheet(
              actions: cupertinoChoices,
              message: message,
              cancelButton: CupertinoActionSheetAction(
                onPressed: () => Navigator.of(callingContext).pop(),
                isDefaultAction: true,
                child: Text(
                  cancelButtonText!,
                  style: const TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            );
          });
    } else {
      final materialLabels = <String>[];

      for (final action in actions) {
        materialLabels.add(action.text);
      }

      showDialog<int>(
          context: callingContext,
          builder: (dialogContext) {
            return RadioButtonDialog(
                title: title,
                buttonLabels: materialLabels,
                cancelText: cancelButtonText,
                confirmText: confirmButtonText,
                message: message,
                onConfirm: (choice) {
                  Navigator.of(dialogContext).pop(choice);
                  completer.complete(choice);
                });
          });
    }
    return completer.future;
  }

  Future<File?> showImagePickerDialog({
    required String optionsTitle,
    required String cameraOption,
    required String galleryOption,
  }) async {
    final picker = ImagePicker();

    final actions = [PlatformChoiceAction(text: cameraOption), PlatformChoiceAction(text: galleryOption)];

    XFile? pickedImage;

    //Ask for source
    final choice = await DialogPresenter.of(callingContext).showPlatformChoiceDialog(
      actions,
      optionsTitle,
      cancel,
      confirm,
    );

    try {
      //Get image
      switch (choice) {
        //Camera
        case 0:
          pickedImage = await picker.pickImage(source: ImageSource.camera);
          break;
        //Gallery
        case 1:
          pickedImage = await picker.pickImage(source: ImageSource.gallery);
          break;
      }
    } on PlatformException catch (_) {
      return null;
    }

    if (pickedImage != null) {
      return File(pickedImage.path);
    } else {
      return null;
    }
  }

  Future<DateTime?> showDatePickerDialog(
    MaterialColor primarySwatch, {
    required DateTime maxDate,
    required DateTime minDate,
    DateTime? initialDate,
  }) async {
    DateTime? picked;
    if (Theme.of(callingContext).platform == TargetPlatform.iOS) {
      picked = await showCupertinoModalPopup<DateTime>(
        context: callingContext,
        builder: (BuildContext context) {
          return IOSDateTimePicker(
            currentDate: initialDate ?? DateTime.now(),
            maxDate: maxDate,
            minDate: minDate,
          );
        },
      );
    } else {
      picked = await showDatePicker(
        context: callingContext,
        initialDate: initialDate ?? DateTime.now(),
        firstDate: minDate,
        lastDate: maxDate,
        // can't be null if infinite like iOS
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.from(
                colorScheme: ColorScheme.fromSwatch(
              primarySwatch: primarySwatch,
              backgroundColor: Colors.white,
            )),
            child: child!,
          );
        },
      );
    }

    return picked;
  }

  Future<TimeOfDay?> showTimeOfDayPickerDialog({
    TimeOfDay? initialTime,
    int minuteInterval = 1,
    bool use24HourFormat = false,
  }) async {
    TimeOfDay? picked;
    var currentDate = DateTime.now();
    if (Theme.of(callingContext).platform == TargetPlatform.iOS) {
      var pickedDateTime = await showCupertinoModalPopup(
          context: callingContext,
          builder: (BuildContext context) {
            if (initialTime != null) {
              currentDate = DateTime(
                currentDate.year,
                currentDate.month,
                currentDate.day,
                initialTime.hour,
                initialTime.minute,
              );
            }
            return IOSDateTimePicker(
              use24HourFormat: use24HourFormat,
              minuteInterval: minuteInterval,
              mode: CupertinoDatePickerMode.time,
              currentDate: currentDate,
              doneButtonText: confirm,
            );
          });

      if (pickedDateTime != null) {
        picked = TimeOfDay.fromDateTime(pickedDateTime);
      }
    } else {
      picked = await showTimePicker(
          context: callingContext,
          initialTime: initialTime ?? TimeOfDay.now(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: use24HourFormat),
              child: child!,
            );
          });
    }

    return picked;
  }
}

class DialogPresenterData extends InheritedWidget {
  final _DialogPresenterState? data;

  DialogPresenterData({
    this.data,
    required Widget child,
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

class PlatformChoiceAction {
  final String text;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  PlatformChoiceAction({
    required this.text,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
  });
}
