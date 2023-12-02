import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ColorExtension on Color {
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}

extension IterableExtension on Iterable {
  Iterable<V> merge<V>() => expand<V>((e) => e).toList();

  Iterable unique() => toSet().toList();
}

extension IterableWidgetExtension on Iterable<Widget> {
  List<Widget> separated(Widget separator) {
    List<Widget> list = map((element) => <Widget>[element, separator]).merge<Widget>().toList();
    if (list.isNotEmpty) list = list..removeLast();
    return list;
  }
}

extension StringExtension on String {
  String get ucFirst => substring(0, 1).toUpperCase() + substring(1);
}

extension DateTimeExtension on DateTime {
  String format(String pattern) => DateFormat(pattern).format(this);

  String formatIso() => format("yyyy-MM-dd'T'HH:mm:ss") + formatTZ();

  String formatTZ() {
    var duration = timeZoneOffset;

    var hours = _pad2(duration.inHours);
    var mins = _pad2(duration.inMinutes - duration.inHours * 60);
    if (duration.isNegative) {
      return '-$hours$mins';
    } else {
      return '+$hours$mins';
    }
  }

  String _pad2(int value) => value.toString().padLeft(2, '0');
}
