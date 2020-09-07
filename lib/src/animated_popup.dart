import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _AnimatedPopup extends StatefulWidget {
  final String title;
  final String message;
  final Widget button;
  final VoidCallback onButtonTap;
  final Color backgroundColor;
  final String backgroundImage;
  final String animation;
  final String animationName;
  final TextStyle titleStyle;
  final TextStyle messageStyle;
  final Duration timerDuration;

  const _AnimatedPopup({
    Key key,
    @required this.title,
    @required this.message,
    this.button,
    this.onButtonTap,
    this.backgroundColor,
    this.backgroundImage,
    this.animation,
    this.animationName,
    this.titleStyle,
    this.messageStyle,
    this.timerDuration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _AnimatedPopupState createState() => _AnimatedPopupState();
}

class _AnimatedPopupState extends State<_AnimatedPopup> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    //If we have a button, use that to close the dialog
    if (widget.button != null) {
      final duration = widget.timerDuration;
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
    const _iconSize = 130.0;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // For Android.
        // Use [light] for white status bar and [dark] for black status bar.
        statusBarIconBrightness: Brightness.light,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
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
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: OverflowBox(
                    maxHeight: 550,
                    maxWidth: 550,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _kGradientFrom.withOpacity(0.5),
                            _kGradientTo.withOpacity(0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
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
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 30),
                          Text(
                            widget.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
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

Future<void> showSuccess(
  BuildContext context, {
  @required String title,
  @required String message,
}) {
  return Navigator.push(
      context,
      FadeUpwardsPageRoute(
        builder: (_) => _AnimatedPopup(title: title, message: message),
        fullscreenDialog: true,
      ));
}
