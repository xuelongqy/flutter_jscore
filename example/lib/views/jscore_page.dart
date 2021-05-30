import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:flutter_jscore/flutter_jscore.dart';

class JsCorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JsCorePageState();
  }
}

class JsCorePageState extends State<JsCorePage> {
  // 输入控制器
  late TextEditingController _jsInputController;

  // 结果
  String? _result;

  // Jsc上下文
  late JSContext _jsContext;

  @override
  void initState() {
    super.initState();
    // 创建js上下文
    _jsContext = JSContext.createInGroup();
    // 注册alert方法
    _alertDartFunc = _alert;
    var jsAlertFunction = JSObject.makeFunctionWithCallback(
        _jsContext, 'alert', Pointer.fromFunction(alert));
    _jsContext.globalObject.setProperty('alert', jsAlertFunction.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeNone);
    // 注册flutter.print静态方法
    _printDartFunc = _print;
    var flutterJSClass = JSClass.create(JSClassDefinition(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'flutter',
      staticFunctions: [
        JSStaticFunction(
          name: 'print',
          callAsFunction: Pointer.fromFunction(flutterPrint),
          attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
        ),
      ],
    ));
    var flutterJSObject = JSObject.make(_jsContext, flutterJSClass);
    _jsContext.globalObject.setProperty('flutter', flutterJSObject.toValue(),
        JSPropertyAttributes.kJSPropertyAttributeDontDelete);
    // 设置默认JavaScript脚本
    _jsInputController = TextEditingController(text: '''
function helloJsCore()
{
    var years = 2000 + 20;
    alert('Hello JavaScriptCore!', years);
    flutter.print('Hello JavaScriptCore!');
    return 'JSCore' + (2000 + 20);
}
helloJsCore();
''');
  }

  @override
  void dispose() {
    _jsInputController.dispose();
    // 释放js上下文
    _jsContext.release();
    super.dispose();
  }

  /// 绑定JavaScript alert()函数
  static Pointer alert(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (_alertDartFunc != null) {
      _alertDartFunc!(
          ctx, function, thisObject, argumentCount, arguments, exception);
    }
    return nullptr;
  }

  static JSObjectCallAsFunctionCallbackDart? _alertDartFunc;
  Pointer _alert(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    String msg = 'No Message';
    if (argumentCount != 0) {
      msg = '';
      for (int i = 0; i < argumentCount; i++) {
        if (i != 0) {
          msg += '\n';
        }
        var jsValueRef = arguments[i];
        msg += JSValue(_jsContext, jsValueRef).string!;
      }
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Alert'),
            content: Text(msg),
          );
        });
    return nullptr;
  }

  /// 绑定flutter.print()函数
  static Pointer flutterPrint(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (_printDartFunc != null) {
      _printDartFunc!(
          ctx, function, thisObject, argumentCount, arguments, exception);
    }
    return nullptr;
  }

  static JSObjectCallAsFunctionCallbackDart? _printDartFunc;
  Pointer _print(
      Pointer ctx,
      Pointer function,
      Pointer thisObject,
      int argumentCount,
      Pointer<Pointer> arguments,
      Pointer<Pointer> exception) {
    if (argumentCount > 0) {
      print(JSValue(_jsContext, arguments[0]).string);
    }
    return nullptr;
  }

  // 运行JavaScript脚本
  String? _runJs(String script) {
    // 运行JavaScript脚本
    var jsValue = _jsContext.evaluate(script);
    // 获取返回结果
    return jsValue.string;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JavaScriptCore for Flutter'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 10.0),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text('JavaScript:'),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border:
                  Border.all(width: 1.0, color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.all(new Radius.circular(5.0)),
            ),
            child: TextField(
              controller: _jsInputController,
              maxLines: 30,
              style: TextStyle(
                fontSize: 12.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text('Result: ${_result ?? ''}'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _result = _runJs(_jsInputController.text);
          });
        },
        child: Icon(Icons.autorenew),
      ),
    );
  }
}
