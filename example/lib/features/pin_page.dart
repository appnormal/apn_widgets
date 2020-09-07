import 'package:apn_widgets/apn_widgets.dart';
import 'package:example/features/shared/example_page.dart';
import 'package:flutter/material.dart';

class PinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      child: _PinPageBody(),
      title: 'Pin Page',
    );
  }
}

class _PinPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode();
    return PinInput(
      showKeyboard: false,
      onCodeCompleted: () => {},
      onChanged: (_) => {},
      spaceBetween: 10,
      pinFieldBuilder: (PinFieldData data) {
        return _PinField(
          height: data.height,
          value: data.value,
          isFocused: data.isFocussed,
        );
      },
      controller: controller,
      focusNode: focusNode,
    );
  }
}

class _PinField extends StatelessWidget {
  final double height;
  final String value;
  final bool isFocused;
  final bool hasError;

  const _PinField({
    Key key,
    this.height,
    this.value,
    this.isFocused = false,
    this.hasError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: isFocused ? Colors.blue : Colors.black),
          borderRadius: BorderRadius.circular(12),
          color: hasError ? Colors.red : Colors.white.withOpacity(0.2),
        ),
        child: Center(
          child: Text(
            value.isNotEmpty ? '.' : '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}