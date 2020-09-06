import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

const _kPlaceholder = '';

class PinInput extends StatefulWidget {
  final double height;
  final double spaceBetween;
  final int numInputs;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onCodeCompleted;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final PinFieldBuilder pinFieldBuilder;

  PinInput({
    Key key,
    this.height = 56,
    this.numInputs = 4,
    this.hasError = false,
    this.spaceBetween = 4,
    @required this.controller,
    @required this.focusNode,
    @required this.pinFieldBuilder,
    this.onCodeCompleted,
    this.onChanged,
  }) : super(key: key);

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  var value1 = _kPlaceholder;
  var value2 = _kPlaceholder;
  var value3 = _kPlaceholder;
  var value4 = _kPlaceholder;

  var previousValue;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() => _updatePinValues(widget.controller.text));

    /// When you dismiss the keyboard on Android,
    /// we un-focus. So we can refocus in the onTap
    KeyboardVisibilityNotification().addNewListener(
      onChange: (visible) {
        if (!visible) widget.focusNode.unfocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.focusNode.requestFocus(),
      child: Row(
        children: [
          widget.pinFieldBuilder(PinFieldData(
            height: widget.height,
            value: value1,
            isFocussed: _isFieldFocused(0),
            hasError: widget.hasError,
          )),
          SizedBox(width: widget.spaceBetween),
          widget.pinFieldBuilder(PinFieldData(
            height: widget.height,
            value: value2,
            isFocussed: _isFieldFocused(1),
            hasError: widget.hasError,
          )),
          SizedBox(width: widget.spaceBetween),
          widget.pinFieldBuilder(PinFieldData(
            height: widget.height,
            value: value3,
            isFocussed: _isFieldFocused(2),
            hasError: widget.hasError,
          )),
          SizedBox(width: widget.spaceBetween),
          widget.pinFieldBuilder(PinFieldData(
            height: widget.height,
            value: value4,
            isFocussed: _isFieldFocused(3),
            hasError: widget.hasError,
          )),

          /// Hidden form field to capture input
          Container(
            width: 0,
            height: 0,
            child: TextFormField(
              keyboardType: TextInputType.number,
              autocorrect: false,
              focusNode: widget.focusNode,
              controller: widget.controller,
              cursorColor: Colors.transparent,
              cursorWidth: 0,
              enableInteractiveSelection: false,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }

  bool _isFieldFocused(int index) {
    if (!widget.focusNode.hasFocus) return false;

    var filledValues = 0;
    if (value1 != _kPlaceholder) filledValues++;
    if (value2 != _kPlaceholder) filledValues++;
    if (value3 != _kPlaceholder) filledValues++;
    if (value4 != _kPlaceholder) filledValues++;

    return index == filledValues;
  }

  void _updatePinValues(String value) {
    final splitted = value.split('');

    if (mounted) {
      setState(() {
        value1 = splitted.isNotEmpty ? splitted[0] : _kPlaceholder;
        value2 = splitted.length > 1 ? splitted[1] : _kPlaceholder;
        value3 = splitted.length > 2 ? splitted[2] : _kPlaceholder;
        value4 = splitted.length > 3 ? splitted[3] : _kPlaceholder;
      });
    }

    if (widget.onCodeCompleted != null && splitted.length == 4 && value != previousValue) {
      widget.onCodeCompleted();
      previousValue = value;
    }
  }
}

class PinFieldData {
  final double height;
  final bool isFocussed;
  final bool hasError;
  final String value;

  PinFieldData({this.height, this.isFocussed, this.hasError, this.value});
}

typedef PinFieldBuilder = Widget Function(PinFieldData data);
