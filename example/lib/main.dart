import 'package:example/features/animated_popup_page.dart';
import 'package:example/features/buttons_page.dart';
import 'package:example/features/dialogs_page.dart';
import 'package:example/features/lists_page.dart';
import 'package:example/features/pin_page.dart';
import 'package:example/features/placeholders_page.dart';
import 'package:example/features/search_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APN Widgets',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text('Buttons'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ButtonsPage())),
            ),
            FlatButton(
              child: Text('Lists'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListsPage())),
            ),
            FlatButton(
              child: Text('Dialogs'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DialogsPage())),
            ),
            FlatButton(
              child: Text('Placeholders & Loaders'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceholdersPage())),
            ),
            FlatButton(
              child: Text('Search'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage())),
            ),
            FlatButton(
              child: Text('Pin'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PinPage())),
            ),
            FlatButton(
              child: Text('Animated popup'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AnimatedPopupPage())),
            )
          ],
        ),
      ),
    );
  }
}
