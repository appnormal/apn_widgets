import 'package:apn_widgets/apn_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

const _kPlaceholder = '';

class PinInput extends StatefulWidget {
  final double height;
  final double spaceBetween;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onCodeCompleted;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final PinFieldBuilder pinFieldBuilder;

  bool get showKeyboard => focusNode != null;

  PinInput({
    Key key,
    this.height = 56,
    this.hasError = false,
    this.spaceBetween = 4,
    @required this.controller,
    @required this.pinFieldBuilder,
    this.focusNode,
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
        if (!visible) widget.focusNode?.unfocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.focusNode?.requestFocus(),
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
              readOnly: !widget.showKeyboard,
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
    if (widget.focusNode != null && !widget.focusNode.hasFocus) return false;

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

class PageInputKeyboard extends StatelessWidget {
  final DigitBuilder digitBuilder;
  final Widget deleteButton;
  final Widget leftAction;
  final TextEditingController controller;

  const PageInputKeyboard({
    Key key,
    @required this.digitBuilder,
    @required this.controller,
    this.leftAction,
    this.deleteButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (BuildContext context, int index) {
            var digit = index + 1;
            if (index == 9) return leftAction ?? Container();
            if (index == 10) digit = 0;
            if (index == 11)
              return deleteButton != null
                  ? GestureDetector(
                      onTap: () {
                        if (controller.text.length > 0) {
                          var pinValues = controller.text.substring(0, controller.text.length - 1);
                          controller.text = pinValues;
                        }
                      },
                      child: deleteButton,
                    )
                  : Container();
            return GestureDetector(
              onTap: () => {
                if (controller.text.length < 4) {controller.text = '${controller.text}$digit'}
              },
              child: digitBuilder(DigitData(digit: digit)),
            );
          }),
    );
  }
}

typedef DigitBuilder = Widget Function(DigitData data);

class DigitData {
  final int digit;

  DigitData({this.digit});
}
