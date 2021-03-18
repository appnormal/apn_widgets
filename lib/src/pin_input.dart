import 'package:apn_widgets/apn_widgets.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

const _kPlaceholder = '';

class PinInput extends StatefulWidget {
  final double height;
  final double spaceBetween;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueSetter<String>? onCodeCompleted;
  final bool hasError;
  final PinFieldBuilder pinFieldBuilder;
  final int pinInputsAmount;

  PinInput({
    Key? key,
    this.height = 56,
    this.hasError = false,
    this.spaceBetween = 4,
    required this.controller,
    required this.pinFieldBuilder,
    this.focusNode,
    this.onCodeCompleted,
    this.pinInputsAmount = 4,
  }) : super(key: key);

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  final values = Map<int, String>();
  var previousValueLength;

  bool get showKeyboard => widget.focusNode != null;

  String get pinCodeValue => widget.controller.text;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() => _updatePinValues(widget.controller.text));

    /// When you dismiss the keyboard on Android,
    /// we un-focus. So we can refocus in the onTap
    KeyboardVisibilityController().onChange.listen(
      (visible) {
        if (!visible) widget.focusNode?.unfocus();
      },
    );

    for (var i = 0; i < widget.pinInputsAmount; i++) {
      values[i] = _kPlaceholder;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pinInputs = _createPinInputs();

    return GestureDetector(
      onTap: () => widget.focusNode?.requestFocus(),
      child: Row(children: pinInputs),
    );
  }

  bool _isFieldFocused(int index) {
    if (widget.focusNode != null && !widget.focusNode!.hasFocus) return false;

    final firstEmpty = values.entries.firstWhereOrNull((entry) => entry.value == _kPlaceholder);
    return firstEmpty?.key == index;
  }

  void _updatePinValues(String value) {
    final splitted = value.split('').asMap();

    if (mounted) {
      setState(() {
        //First reset the values map
        values.clear();

        //Then fill it with placeholders again
        for (var i = 0; i < widget.pinInputsAmount; i++) {
          values[i] = splitted.entries
              .firstWhere(
                (entry) => entry.key == i,
                orElse: () => MapEntry(0, _kPlaceholder),
              )
              .value;
        }
      });
    }

    if (widget.onCodeCompleted != null &&
        splitted.length == widget.pinInputsAmount &&
        splitted.length != previousValueLength) {
      widget.onCodeCompleted!(pinCodeValue);
    }

    previousValueLength = splitted.length;
  }

  List<Widget> _createPinInputs() {
    final inputs = <Widget>[];

    values.forEach((index, value) {
      inputs.add(widget.pinFieldBuilder(PinFieldData(
        height: widget.height,
        value: value,
        isFocussed: _isFieldFocused(index),
        hasError: widget.hasError,
      )));
    });

    final List<Widget> pinInputs =
        inputs.separated(SizedBox(width: widget.spaceBetween)).cast<Widget>() as List<Widget>;

    /// Hidden form field to capture input

    pinInputs.add(
      Container(
        width: 0,
        height: 0,
        child: TextFormField(
          readOnly: !showKeyboard,
          keyboardType: TextInputType.number,
          autocorrect: false,
          focusNode: widget.focusNode,
          controller: widget.controller,
          cursorColor: Colors.transparent,
          cursorWidth: 0,
          enableInteractiveSelection: false,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.pinInputsAmount),
          ],
        ),
      ),
    );

    return pinInputs;
  }
}

class PinFieldData {
  final double? height;
  final bool? isFocussed;
  final bool? hasError;
  final String? value;

  PinFieldData({this.height, this.isFocussed, this.hasError, this.value});
}

typedef PinFieldBuilder = Widget Function(PinFieldData data);

class PageInputKeyboard extends StatelessWidget {
  final DigitBuilder digitBuilder;
  final Widget? deleteButton;
  final Widget? leftAction;
  final TextEditingController controller;
  final double horizontalSpacing;
  final double verticalSpacing;
  final ShapeBorder? shapeBorder;
  final double childAspectRatio;
  final int pinInputsAmount;

  const PageInputKeyboard({
    Key? key,
    required this.digitBuilder,
    required this.controller,
    this.leftAction,
    this.deleteButton,
    this.horizontalSpacing = 20,
    this.verticalSpacing = 20,
    this.shapeBorder,
    this.childAspectRatio = 1,
    this.pinInputsAmount = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> digitWidgets = [];

    for (var i = 1; i < 13; i++) {
      var digit = i;
      //Make the bottom digit show 0 like on a numpad
      if (i == 11) digit = 0;
      digitWidgets.add(TappableOverlay(
        shape: shapeBorder,
        onTap: () => {
          if (controller.text.length < pinInputsAmount) {controller.text = '${controller.text}$digit'}
        },
        child: digitBuilder(
          DigitData(digit: digit),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [digitWidgets[0], digitWidgets[1], digitWidgets[2]].separated(SizedBox(
            width: horizontalSpacing,
          )) as List<Widget>,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [digitWidgets[3], digitWidgets[4], digitWidgets[5]].separated(SizedBox(
            width: horizontalSpacing,
          )) as List<Widget>,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [digitWidgets[6], digitWidgets[7], digitWidgets[8]].separated(SizedBox(
            width: horizontalSpacing,
          )) as List<Widget>,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leftAction ??
                Visibility(
                  maintainSize: true,
                  maintainState: true,
                  maintainAnimation: true,
                  child: digitWidgets[9],
                  visible: false,
                ),
            digitWidgets[10],
            deleteButton != null
                ? TappableOverlay(
                    shape: shapeBorder,
                    onTap: () {
                      if (controller.text.length > 0) {
                        var pinValues = controller.text.substring(0, controller.text.length - 1);
                        controller.text = pinValues;
                      }
                    },
                    child: Center(child: deleteButton),
                  )
                : Container()
          ].separated(SizedBox(
            width: horizontalSpacing,
          )) as List<Widget>,
        )
      ].separated(SizedBox(
        height: verticalSpacing,
      )) as List<Widget>,
    );
  }
}

typedef DigitBuilder = Widget Function(DigitData data);

class DigitData {
  final int? digit;

  DigitData({this.digit});
}
