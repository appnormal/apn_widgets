import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSDateTimePicker extends StatefulWidget {
  final DateTime currentDate;
  final DateTime maxDate;
  final DateTime minDate;
  final CupertinoDatePickerMode mode;
  final int minuteInterval;
  final String doneButtonText;
  final bool use24HourFormat;

  const IOSDateTimePicker({
    Key key,
    this.currentDate,
    this.maxDate,
    this.minDate,
    this.mode,
    this.minuteInterval = 1,
    this.doneButtonText,
    this.use24HourFormat,
  }) : super(key: key);

  @override
  _IOSDateTimePickerState createState() => _IOSDateTimePickerState();
}

class _IOSDateTimePickerState extends State<IOSDateTimePicker> {
  DateTime pickedDate;

  @override
  void initState() {
    super.initState();
    pickedDate = widget.currentDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 216,
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            CupertinoButton(
              child: Text(
                widget.doneButtonText ?? 'Done',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: CupertinoColors.activeBlue,
                ),
              ),
              onPressed: () => Navigator.pop<DateTime>(context, pickedDate),
            ),
            Expanded(
              child: CupertinoDatePicker(
                minuteInterval: widget.minuteInterval,
                mode: widget.mode ?? CupertinoDatePickerMode.date,
                initialDateTime: pickedDate ?? DateTime.now(),
                maximumDate: widget.maxDate,
                minimumDate: widget.minDate ?? DateTime(1900),
                use24hFormat: widget.use24HourFormat ?? false,
                onDateTimeChanged: (DateTime newDateTime) {
                  setState(() {
                    pickedDate = newDateTime;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
