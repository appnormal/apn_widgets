
import 'package:apn_widgets/src/platform_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'tappable_overlay.dart';

const kDefaultButtonHeight = 55.0;

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool loading;
  final List<BoxShadow> boxShadow;

  const PrimaryButton({
    Key key,
    @required this.title,
    this.onPressed,
    this.boxShadow,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (loading) {
      child = PlatformLoader(
        cupertinoTintColor: Colors.white.withOpacity(0.5),
        cupertinoActiveTintColor: Colors.white,
        materialColor: Colors.white,
      );
    } else {
      child = Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      );
    }

    return PlatformButton(
      child: Center(child: child),
      onTap: !loading ? onPressed : null,
      borderRadius: BorderRadius.circular(12),
      boxShadow: boxShadow,
      color: Theme.of(context).primaryColor,
    );
  }
}

class PlatformButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;

  const PlatformButton({
    Key key,
    @required this.child,
    @required this.onTap,
    this.color,
    this.padding,
    this.boxShadow,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget button;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      button = CupertinoButton(
        minSize: kDefaultButtonHeight,
        borderRadius: borderRadius,
        onPressed: onTap,
        color: color ?? Theme.of(context).primaryColor,
        disabledColor: Theme.of(context).primaryColor,
        pressedOpacity: 0.7,
        padding: padding ??
            EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
        child: child,
      );
    } else {
      button = Material(
        borderRadius: borderRadius,
        color: color ?? Theme.of(context).primaryColor,
        child: InkWell(
          borderRadius: borderRadius,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: 56),
            child: Center(
              child: Padding(
                padding: padding ??
                    EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                child: child,
              ),
            ),
          ),
          onTap: onTap,
        ),
      );
    }

    if (boxShadow != null) {
      button = Container(decoration: BoxDecoration(boxShadow: boxShadow), child: button);
    }

    return button;
  }
}

class AppBarAction extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final EdgeInsets padding;
  final Color color;

  const AppBarAction({
    Key key,
    this.onTap,
    this.child,
    this.padding = EdgeInsets.zero,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TappableOverlay(
      color: Colors.white,
      pressedColor: Colors.white,
      highlightColor: Theme.of(context).accentColor.withOpacity(0.2),
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
