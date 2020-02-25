import 'package:flutter/material.dart';
import 'package:flutter_jscore_example/utils/h2dart.dart';

/// 头文件转dart
class H2DartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return H2DartPageState();
  }
}

class H2DartPageState extends State<H2DartPage> {
  TextEditingController _hController;
  TextEditingController _dartController;

  @override
  void initState() {
    _hController = TextEditingController();
    _dartController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _hController.dispose();
    _dartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('.h to .dart'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: () {
              _dartController.text = h2Dart(_hController.text);
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Text('.h'),
          TextField(
            controller: _hController,
            maxLines: 20,
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
          Text('.dart'),
          TextField(
            controller: _dartController,
            maxLines: 20,
            style: TextStyle(
              fontSize: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
