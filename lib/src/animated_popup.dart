import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _AnimatedPopup extends StatefulWidget {
  final String title;
  final String message;
  final Widget button;
  final Color backgroundColor;
  final String backgroundImage;
  final String animation;
  final String animationName;
  final TextStyle titleStyle;
  final TextStyle messageStyle;
  final Duration timerDuration;
  final Brightness statusbarBrightness;

  const _AnimatedPopup({
    Key key,
    @required this.title,
    @required this.message,
    this.button,
    this.backgroundColor,
    this.backgroundImage,
    this.animation,
    this.animationName,
    this.titleStyle,
    this.messageStyle,
    this.timerDuration,
    this.statusbarBrightness = Brightness.light,
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

    statusBarBrightness = widget.statusbarBrightness ?? Brightness.light;
  }

  @override
  void dispose() {
    //Avoid trying to execute the timer when the widget is already disposed
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const _iconSize = 130.0;

    if (widget.statusbarBrightness == Brightness.light && Theme.of(context).platform == TargetPlatform.iOS) {
      // For Android.
      // Use [light] for white status bar and [dark] for black status bar.

      // For iOS.
      // Use [dark] for white status bar and [light] for black status bar.
      statusBarBrightness = Brightness.dark;
    } else if (widget.statusbarBrightness == Brightness.dark && Theme.of(context).platform == TargetPlatform.iOS) {
      statusBarBrightness = Brightness.light;
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: statusBarBrightness,
        statusBarBrightness: statusBarBrightness,
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              color: widget.backgroundColor ?? Colors.white,
              image: widget.backgroundImage != null
                  ? DecorationImage(
                      image: AssetImage(widget.backgroundImage),
                      fit: BoxFit.cover,
                    )
                  : null),
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.antiAlias,
            children: [
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: _iconSize),
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
                            SizedBox(height: 30),
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
                    if (widget.button != null) ...[
                      Expanded(
                        child: Container(),
                      ),
                      widget.button
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeUpwardsPageRoute<T> extends MaterialPageRoute<T> {
  FadeUpwardsPageRoute({
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
  Widget button,
  Color backgroundColor,
  String backgroundImage,
  String animation,
  String animationName,
  TextStyle titleStyle,
  TextStyle messageStyle,
  Duration timerDuration,
}) {
  return Navigator.push(
      context,
      FadeUpwardsPageRoute(
        builder: (_) => _AnimatedPopup(
          title: title,
          message: message,
          button: button,
          backgroundColor: backgroundColor,
          backgroundImage: backgroundImage,
          animation: animation,
          animationName: animationName,
          titleStyle: titleStyle,
          messageStyle: messageStyle,
          timerDuration: timerDuration,
        ),
        fullscreenDialog: true,
      ));
}
