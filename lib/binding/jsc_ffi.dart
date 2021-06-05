import 'dart:ffi';
import 'dart:io';

final DynamicLibrary jscLib = Platform.isIOS || Platform.isMacOS
    ? DynamicLibrary.open('JavaScriptCore.framework/JavaScriptCore')
    : Platform.isWindows
        ? DynamicLibrary.open('JavaScriptCore.dll')
        : Platform.isLinux
            ? DynamicLibrary.open(
                '${File(Platform.resolvedExecutable).parent.path}/lib/libjsc.so')
            : DynamicLibrary.open('libjsc.so');
