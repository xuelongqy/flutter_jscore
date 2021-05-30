import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jscore/jscore_bindings.dart';
import 'package:ffi/ffi.dart';

class BindingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BindingsPageState();
  }
}

class BindingsPageState extends State<BindingsPage> {
  // 输入控制器
  late TextEditingController _jsInputController;

  // 结果
  String? _result;

  // Jsc上下文
  late Pointer contextGroup;
  late Pointer globalContext;
  late Pointer globalObject;

  @override
  void initState() {
    super.initState();
    // 创建js上下文
    contextGroup = jSContextGroupCreate();
    globalContext = jSGlobalContextCreateInGroup(contextGroup, nullptr);
    globalObject = jSContextGetGlobalObject(globalContext);
    // 注册alert方法
    _alertDartFunc = _alert;
    Pointer<Utf8> funcNameCString = 'alert'.toNativeUtf8();
    var functionObject = jSObjectMakeFunctionWithCallback(
        globalContext,
        jSStringCreateWithUTF8CString(funcNameCString),
        Pointer.fromFunction(alert));
    jSObjectSetProperty(
        globalContext,
        globalObject,
        jSStringCreateWithUTF8CString(funcNameCString),
        functionObject,
        JSPropertyAttributes.kJSPropertyAttributeNone,
        nullptr);
    malloc.free(funcNameCString);
    // 注册flutter.print静态方法
    _printDartFunc = _print;
    var staticFunctions = JSStaticFunctionPointer.allocateArray([
      JSStaticFunctionStruct(
        name: 'print'.toNativeUtf8(),
        callAsFunction: Pointer.fromFunction(flutterPrint),
        attributes: JSPropertyAttributes.kJSPropertyAttributeNone,
      ),
    ]);
    var definition = JSClassDefinitionPointer.allocate(
      version: 0,
      attributes: JSClassAttributes.kJSClassAttributeNone,
      className: 'flutter'.toNativeUtf8(),
      parentClass: null,
      staticValues: null,
      staticFunctions: staticFunctions,
      initialize: null,
      finalize: null,
      hasProperty: null,
      getProperty: null,
      setProperty: null,
      deleteProperty: null,
      getPropertyNames: null,
      callAsFunction: null,
      callAsConstructor: null,
      hasInstance: null,
      convertToType: null,
    );
    var flutterJSClass = jSClassCreate(definition);
    var flutterJSObject = jSObjectMake(globalContext, flutterJSClass, nullptr);
    Pointer<Utf8> flutterCString = 'flutter'.toNativeUtf8();
    jSObjectSetProperty(
        globalContext,
        globalObject,
        jSStringCreateWithUTF8CString(flutterCString),
        flutterJSObject,
        JSPropertyAttributes.kJSPropertyAttributeDontDelete,
        nullptr);
    malloc.free(flutterCString);
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
    jSContextGroupRelease(contextGroup);
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
        msg += _getJsValue(jsValueRef);
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
      print(_getJsValue(arguments[0]));
    }
    return nullptr;
  }

  // 运行JavaScript脚本
  String _runJs(String script) {
    // 运行JavaScript脚本
    Pointer<Utf8> scriptCString = script.toNativeUtf8();
    var jsValueRef = jSEvaluateScript(
        globalContext,
        jSStringCreateWithUTF8CString(scriptCString),
        nullptr,
        nullptr,
        1,
        nullptr);
    malloc.free(scriptCString);
    // 获取返回结果
    String result = _getJsValue(jsValueRef);
    return result;
  }

  // 获取JsValue的值
  String _getJsValue(Pointer jsValueRef) {
    if (jSValueIsNull(globalContext, jsValueRef) == 1) {
      return 'null';
    } else if (jSValueIsUndefined(globalContext, jsValueRef) == 1) {
      return 'undefined';
    }
    var resultJsString =
        jSValueToStringCopy(globalContext, jsValueRef, nullptr);
    var resultCString = jSStringGetCharactersPtr(resultJsString);
    int resultCStringLength = jSStringGetLength(resultJsString);
    if (resultCString == nullptr) {
      return 'null';
    }
    String result = String.fromCharCodes(Uint16List.view(
        resultCString.cast<Uint16>().asTypedList(resultCStringLength).buffer,
        0,
        resultCStringLength));
    jSStringRelease(resultJsString);
    return result;
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
