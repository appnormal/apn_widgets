import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarBrightness extends StatelessWidget {
  final Widget child;
  final Brightness statusBarBrightness;

  const StatusBarBrightness({
    Key key,
    @required this.child,
    this.statusBarBrightness = Brightness.light,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = statusBarBrightness;

    // For Android.
    // Use [light] for white status bar and [dark] for black status bar.

    // For iOS.
    // Use [dark] for white status bar and [light] for black status bar.
    if (statusBarBrightness == Brightness.light && Theme.of(context).platform == TargetPlatform.iOS) {
      brightness = Brightness.dark;
    } else if (statusBarBrightness == Brightness.dark && Theme.of(context).platform == TargetPlatform.iOS) {
      brightness = Brightness.light;
    }
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness
      ),
      child: child,
    );
  }
}
