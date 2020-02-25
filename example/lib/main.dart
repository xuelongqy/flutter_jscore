import 'package:flutter/material.dart';
import 'package:flutter_jscore_example/views/h2dart_page.dart';
import 'package:flutter_jscore_example/views/bindings_page.dart';
import 'package:flutter_jscore_example/views/jscore_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_jscore',
      home: FlutterJsCorePage(),
    );
  }
}

class FlutterJsCorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JavaScriptCore for Flutter'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('H2Dart tool'),
            subtitle: Text('C .h file to dart file'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return H2DartPage();
              }));
            },
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
          ),
          ListTile(
            title: Text('Bindings page'),
            subtitle: Text('Dart binding C'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return BindingsPage();
              }));
            },
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
          ),
          ListTile(
            title: Text('JsCore page'),
            subtitle: Text('Use flutter_jscore lib'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return JsCorePage();
              }));
            },
          ),
        ],
      ),
    );
  }
}