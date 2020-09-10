import 'package:apn_widgets/apn_widgets.dart';
import 'package:example/features/shared/example_page.dart';
import 'package:flutter/material.dart';

class PinPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExamplePage(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
                child: Text('With Keyboard'),
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => _PinPageKeyboardBody()))),
            FlatButton(
                child: Text('With custom input'),
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => _PinPageCustomBody()))),
          ],
        ),
      ),
      title: 'Pin Page',
    );
  }
}

class _PinPageKeyboardBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode();
    return ExamplePage(
      title: 'Pin with keyboard',
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PinInput(
          controller: controller,
          spaceBetween: 10,
          focusNode: focusNode,
          hasError: false,
          onCodeCompleted: (pinCode) {},
          pinFieldBuilder: (data) => _PinField(
            height: data.height,
            value: data.value,
            isFocused: data.isFocussed,
            hasError: false,
          ),
        ),
      ),
    );
  }
}

class _PinPageCustomBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return ExamplePage(
        title: 'Pin with custom input',
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(children: [
            PinInput(
              controller: controller,
              spaceBetween: 10,
              hasError: false,
              //If this is changed also change the value of pageInputKeyboard
              pinInputsAmount: 5,
              onCodeCompleted: (pinCode) => {},
              pinFieldBuilder: (data) => _PinField(
                height: data.height,
                value: data.value,
                isFocused: data.isFocussed,
                hasError: false,
              ),
            ),
            SizedBox(height: 50),
            PageInputKeyboard(
              pinInputsAmount: 5,
              controller: controller,
              deleteButton: _DeleteButton(),
              digitBuilder: (DigitData data) => _CustomInput(value: data.digit),
            ),
          ]),
        ));
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onDeleteTapped;

  const _DeleteButton({Key key, this.onDeleteTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('DEL'),
    );
  }
}

class _CustomInput extends StatelessWidget {
  final int value;

  const _CustomInput({
    Key key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TappableOverlay(
        onTap: () {},
        child: Text('$value'),
      ),
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
