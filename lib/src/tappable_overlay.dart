import 'package:flutter/material.dart';

import 'extensions.dart';

/// Used primarily for cards, ripple on Android and animated pressed color on iOS
class TappableOverlay extends StatefulWidget {
  final VoidCallback onTap;

  // The color of the ripple on Android
  final Color highlightColor;

  // The pressed color on iOS also used on Android if highLight color is null.
  // If this value is also null color will be used as a base color
  final Color pressedColor;
  final Widget child;
  final double width;
  final double height;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final HitTestBehavior behaviour;
  final bool disableIosTappable;
  final ShapeBorder shape;

  final bool expandWidth, expandHeight;

  const TappableOverlay({
    Key key,
    @required this.child,
    @required this.onTap,
    Color color,
    this.highlightColor,
    this.pressedColor,
    this.width,
    this.height,
    this.margin,
    this.expandHeight = false,
    this.expandWidth = false,
    this.borderRadius,
    this.behaviour,
    this.disableIosTappable = false,
    this.shape,
  })
      : assert(
  (expandWidth == true && expandHeight == false) ||
      (expandWidth == false && expandHeight == true) ||
      (expandWidth == false && expandHeight == false),
  'Setting both expand width and expand height is not allowed'),
        super(key: key);

  @override
  _TappableOverlayState createState() => _TappableOverlayState();
}

class _TappableOverlayState extends State<TappableOverlay> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final isIos = Theme
        .of(context)
        .platform == TargetPlatform.iOS || widget.disableIosTappable;
    final pressedColor = (widget.pressedColor ?? Colors.white).withOpacity(0.3);
    final highlightColor = widget.highlightColor ?? pressedColor.darken().withOpacity(0.2);

    var child = widget.child;

    if (widget.expandHeight) {
      child = Column(children: [Expanded(child: child)]);
    }
    if (widget.expandWidth) {
      child = Row(children: [Expanded(child: child)]);
    }

    final hiddenChild = Visibility(
      child: child,
      visible: false,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
    );

    if (isIos) {
      child = Container(
        width: widget.width,
        margin: widget.margin,
        child: GestureDetector(
          onTapDown: (details) => onTapDown(),
          onTapUp: (details) => onTapUp(),
          onTapCancel: onTapUp,
          onTap: widget.onTap,
          behavior: widget.behaviour ?? HitTestBehavior.deferToChild,
          child: Stack(
            fit: StackFit.loose,
            children: [
              child,
              AnimatedOpacity(
                opacity: pressed ? 1 : 0,
                duration: Duration(milliseconds: 100),
                child: Material(
                  shape: widget.shape,
                  borderRadius: widget.borderRadius,
                  color: pressedColor,
                  child: hiddenChild, // Hidden child so the tap is the size of the child
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      child = Container(
        margin: widget.margin,
        child: Stack(
          fit: StackFit.loose,
          children: [
            child,
            Material(
              borderRadius: widget.borderRadius,
              color: Colors.transparent,
              child: InkWell(
                borderRadius: widget.borderRadius,
                customBorder: widget.shape,
                splashColor: highlightColor,
                highlightColor: highlightColor,
                child: hiddenChild,
                onTap: widget.onTap,
              ),
            ),
          ],
        ),
      );
    }

    return child;
  }

  void onTapUp() {
    setState(() {
      pressed = false;
    });
  }

  void onTapDown() {
    setState(() {
      pressed = true;
    });
  }
}
