import 'dart:ffi';
import 'dart:io';

final DynamicLibrary jscLib = Platform.isIOS || Platform.isMacOS
    ? DynamicLibrary.open("JavaScriptCore.framework/JavaScriptCore")
    : Platform.isWindows
        ? DynamicLibrary.open("JavaScriptCore.dll")
        : DynamicLibrary.open("libjsc.so");
