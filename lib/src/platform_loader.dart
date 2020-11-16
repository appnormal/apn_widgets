// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const double _kDefaultIndicatorRadius = 10.0;

class PlatformLoader extends StatelessWidget {
  final Color cupertinoTintColor;
  final Color cupertinoActiveTintColor;
  final Color materialColor;

  const PlatformLoader({
    this.cupertinoTintColor,
    this.cupertinoActiveTintColor,
    this.materialColor,
  });

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoActivityIndicator(
        tintColor: cupertinoTintColor,
        activeTintColor: cupertinoActiveTintColor,
      );
    } else {
      return Container(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(materialColor ?? Theme.of(context).primaryColor),
          strokeWidth: 3,
        ),
        height: 20,
        width: 20,
      );
    }
  }
}

/// An iOS-style activity indicator.
///
/// See also:
///
///  * <https://developer.apple.com/ios/human-interface-guidelines/controls/progress-indicators/#activity-indicators>
class CupertinoActivityIndicator extends StatefulWidget {
  /// Creates an iOS-style activity indicator.
  const CupertinoActivityIndicator(
      {Key key,
      this.animating = true,
      this.radius = _kDefaultIndicatorRadius,
      this.tintColor = CupertinoColors.lightBackgroundGray,
      this.activeTintColor})
      : assert(animating != null),
        assert(radius != null),
        assert(radius > 0),
        super(key: key);

  /// Whether the activity indicator is running its animation.
  ///
  /// Defaults to true.
  final bool animating;

  /// The display color of the ticker
  ///
  /// Defaults to CupertinoColors.lightBackgroundGray
  final Color tintColor;

  final Color activeTintColor;

  /// Radius of the spinner widget.
  ///
  /// Defaults to 10px. Must be positive and cannot be null.
  final double radius;

  @override
  _CupertinoActivityIndicatorState createState() => _CupertinoActivityIndicatorState();
}

class _CupertinoActivityIndicatorState extends State<CupertinoActivityIndicator> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) _controller.repeat();
  }

  @override
  void didUpdateWidget(CupertinoActivityIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CupertinoActivityIndicatorPainter(
          color: widget.tintColor,
          activeColor: widget.activeTintColor ?? Color(0xFF9D9D9D),
          position: _controller,
          radius: widget.radius,
        ),
      ),
    );
  }
}

const double _kTwoPI = math.pi * 2.0;
const int _kTickCount = 12;
const int _kHalfTickCount = _kTickCount ~/ 2;

class _CupertinoActivityIndicatorPainter extends CustomPainter {
  _CupertinoActivityIndicatorPainter({
    this.position,
    this.color,
    this.activeColor,
    double radius,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          1.0 * radius / _kDefaultIndicatorRadius,
          -radius / 2.0,
          -1.0 * radius / _kDefaultIndicatorRadius,
          1.0,
          1.0,
        ),
        super(repaint: position);

  final Animation<double> position;
  final RRect tickFundamentalRRect;
  final Color color;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final activeTick = (_kTickCount * position.value).floor();

    for (var i = 0; i < _kTickCount; ++i) {
      final double t = (((i + activeTick) % _kTickCount) / _kHalfTickCount).clamp(0.0, 1.0);
      paint.color = Color.lerp(activeColor, color, t);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_kTwoPI / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CupertinoActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position;
  }
}
