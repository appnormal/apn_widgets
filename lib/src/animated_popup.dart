import 'dart:async';

import 'package:apn_widgets/apn_widgets.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _AnimatedPopup extends StatefulWidget {
  final String title;
  final String message;
  final String animation;
  final String animationName;
  final Widget button;
  final TextStyle titleStyle;
  final TextStyle messageStyle;
  final Duration timerDuration;
  final Brightness statusBarBrightness;
  final BoxDecoration decoration;
  final double iconSize;
  final double iconSpacing;

  const _AnimatedPopup({
    Key key,
    @required this.title,
    @required this.message,
    @required this.decoration,
    this.button,
    this.animation,
    this.animationName,
    this.titleStyle,
    this.messageStyle,
    this.timerDuration,
    this.statusBarBrightness = Brightness.light,
    this.iconSize = 130,
    this.iconSpacing = 30,
  }) : super(key: key);

  @override
  _AnimatedPopupState createState() => _AnimatedPopupState();
}

class _AnimatedPopupState extends State<_AnimatedPopup> {
  Timer timer;
  Brightness statusBarBrightness;

  @override
  void initState() {
    super.initState();
    //If we have a button, use that to close the dialog
    if (widget.button == null) {
      final duration = widget.timerDuration ?? Duration(seconds: 2);
      timer = Timer(duration, () => Navigator.of(context).pop());
    }
  }

  @override
  void dispose() {
    //Avoid trying to execute the timer when the widget is already disposed
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatusBarBrightness(
      statusBarBrightness: statusBarBrightness,
      child: Scaffold(
        body: Container(
          decoration: widget.decoration,
          child: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.antiAlias,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: widget.iconSize),
                      child: widget.animation != null
                          ? FlareActor(
                              widget.animation,
                              animation: widget.animationName,
                            )
                          : Container(),
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 280),
                        child: Column(
                          children: [
                            Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: widget.titleStyle ??
                                  TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                            ),
                            SizedBox(height: widget.iconSpacing),
                            Text(
                              widget.message,
                              textAlign: TextAlign.center,
                              style: widget.messageStyle ??
                                  TextStyle(
                                    height: 2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.button != null)
                  Positioned(
                      child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: widget.button,
                  )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FadeUpwardsPageRoute<T> extends MaterialPageRoute<T> {
  _FadeUpwardsPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
          builder: builder,
          settings: settings,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeUpwardsPageTransitionsBuilder().buildTransitions(
      this,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}

Future<void> showAnimatedPopup(
  BuildContext context, {
  @required String title,
  @required String message,
  @required BoxDecoration decoration,
  String animation,
  String animationName,
  Widget button,
  TextStyle titleStyle,
  TextStyle messageStyle,
  Duration timerDuration,
  Brightness statusBarBrightness,
  double iconSize,
  double iconSpacing,
}) {
  return Navigator.push(
      context,
      _FadeUpwardsPageRoute(
        builder: (_) => _AnimatedPopup(
          title: title,
          message: message,
          button: button,
          animation: animation,
          animationName: animationName,
          titleStyle: titleStyle,
          messageStyle: messageStyle,
          timerDuration: timerDuration,
          decoration: decoration,
          statusBarBrightness: statusBarBrightness,
          iconSize: iconSize,
          iconSpacing: iconSpacing,
        ),
        fullscreenDialog: true,
      ));
}

Future<void> showSuccessPopup(
  BuildContext context, {
  @required String title,
  @required String message,
  @required BoxDecoration decoration,
  TextStyle titleStyle,
  TextStyle messageStyle,
  Brightness statusBarBrightness,
  double iconSize,
  double iconSpacing,
}) =>
    showAnimatedPopup(context,
        title: title,
        message: message,
        decoration: decoration,
        animation: 'packages/apn_widgets/lib/assets/animations/success_check.flr',
        animationName: 'activate',
        titleStyle: titleStyle,
        messageStyle: messageStyle,
        statusBarBrightness: statusBarBrightness,
        iconSize: iconSize,
        iconSpacing: iconSpacing);
