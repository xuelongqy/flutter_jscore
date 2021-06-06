# flutter_jscore

[![License](https://img.shields.io/badge/license-MIT-green.svg)](/LICENSE)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://stackoverflow.com/questions/tagged/flutter?sort=votes)
[![Pub](https://img.shields.io/pub/v/flutter_jscore)](https://pub.flutter-io.cn/packages/flutter_jscore)

JavaScriptCore for Flutter. The plugin provides the ability to evaluate JavaScript programs from within dart.

### Demo
|Screen recording|Apk|
|:---:|:---:|
|![](https://raw.githubusercontent.com/xuelongqy/flutter_jscore/master/example/art/flutter_jscore.gif)|![](https://raw.githubusercontent.com/xuelongqy/flutter_jscore/master/example/art/apk_QRCode.png)|
|[Code](https://github.com/xuelongqy/flutter_jscore/blob/master/example/lib/views/jscore_page.dart)|[Download](https://raw.githubusercontent.com/xuelongqy/flutter_jscore/master/example/art/flutter_jscore.apk)|

## Getting Started

### Add plugin
```yaml
// pub
dependencies:
  flutter_jscore: ^last_version

// import
dependencies:
  flutter_jscore:
    path: Your local path

// git
dependencies:
  flutter_jscore:
    git:
      url: git://github.com/xuelongqy/flutter_jscore.git
```

### Add dynamic library

Due to the size limitation of pub on package upload, you need to add JavaScriptCore dynamic library to the project by yourself.  
You can refer to the [example](https://github.com/xuelongqy/flutter_jscore/tree/master/example). of course you can refer to [webkit](https://webkit.org/getting-the-code/) to compile it.  
Set JscFfi.lib to use the JavaScriptCore dynamic library.  
```dart
JscFfi.lib = Platform.isIOS || Platform.isMacOS
  ? DynamicLibrary.open('JavaScriptCore.framework/JavaScriptCore')
  : Platform.isWindows
  ? DynamicLibrary.open('JavaScriptCore.dll')
  : Platform.isLinux
  ? DynamicLibrary.open('libjavascriptcoregtk-4.0.so.18')
  : DynamicLibrary.open('libjsc.so');
```

#### Android

You can get the aar file containing libjsc.so in [jsc-android](https://www.npmjs.com/package/jsc-android), and add to your project.  
Take the [libs](https://github.com/xuelongqy/flutter_jscore/tree/master/example/android/app/libs) folder as an example, add it to the build.gradle of the module.
```groovy
android {
    repositories {
        flatDir {
            dirs 'libs'
        }
    }
}
dependencies {
    implementation(name:'**', ext:'aar')
}
```
You also need to add libc++_shared.so, because this is a dependency of libjsc.so.  
Take the [jniLibs](https://github.com/xuelongqy/flutter_jscore/tree/master/example/android/app/jniLibs) folder as an example, add it to the build.gradle of the module.
```groovy
android {
    sourceSets {
        main {
            jniLibs.srcDirs = ['jniLibs']
        }
    }
}
```
If your project uses C++, then you can add the code in the module’s build.gradle.
```groovy
android {
    defaultConfig {
        externalNativeBuild {
            make {
                arguments "-DANDROID_STL=c++_shared"
            }
        }
    }
}
```

#### iOS and macOS

You don’t need to do anything, because JavaScriptCore comes with iOS and macOS.

#### Windows

You can use the dynamic library in the [example](https://github.com/xuelongqy/flutter_jscore/tree/master/example/windows/JavaScriptCore), or compile it yourself. And configure in CMakeLists.txt.
```text
# Add JavaScriptCore libs
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/JavaScriptCore/"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)
```

#### Linux

You can use libjavascriptcoregtk as a dependency, or compile [webkitgtk](https://webkitgtk.org/) yourself.  
The names of dynamic libraries in different Linux distributions may be different. So you need to set JscFfi.lib.  

ubuntn or Debian
```shell
apt-get install libjavascriptcoregtk-4.0-18
```
```dart
JscFfi.lib = DynamicLibrary.open('libjavascriptcoregtk-4.0.so.18');
```

Archlinux
```shell
pacman -S webkit2gtk
```
```dart
JscFfi.lib = DynamicLibrary.open('libjavascriptcoregtk-4.0.so');
```

### Usage
```dart
import 'package:flutter_jscore/flutter_jscore.dart';

void runJS() {
    JSContext jsContext = JSContext.createInGroup();
    // Replace '1 + 1' with your JavaScript code
    JSValue jsValue = jsContext.evaluate('1 + 1');
    print(jsValue.string);
    jsContext.release();
}
```

## JavaScriptCore

Evaluate JavaScript programs from within an app, and support JavaScript scripting of your app.

[Documentation](https://developer.apple.com/documentation/javascriptcore)

## dart:ffi

Foreign Function Interface for interoperability with the C programming language. flutter_jscore uses dart:ffi so you don't have to worry about performance loss across programming languages.

[dart:ffi](https://api.dart.dev/stable/dart-ffi/dart-ffi-library.html)

## Supported platforms

 - iOS (7.0+) 
 - macOS (10.5+) 
 - Android (arm32, arm64, x86, x86_64) 
 - Windows (x86_64) 
 - Linux (x86_64) 
 
## Linux dependencies

If you use it on Linux, you must make sure to have the following dependencies.

 - libglib-2.0.so.0
 - libicui18n.so.66
 - libicuuc.so.66
 - libdl.so.2
 - libgio-2.0.so.0
 - libgobject-2.0.so.0
 - libpthread.so.0
 - libstdc++.so.6
 - libm.so.6
 - libgcc_s.so.1
 - libc.so.6
 - ld-linux-x86-64.so.2

## APIs
 
I don't think there is much to describe, flutter_jscore just makes a simple package. You can refer to the documentation of JavaScriptCore and the documentation on pub.

[JavaScriptCore](https://developer.apple.com/documentation/javascriptcore)

[flutter_jscore](https://pub.dev/documentation/flutter_jscore/latest/)
 
 ## Donation
 If you like my project, please in the upper right corner of the project "Star". Your support is my biggest encouragement! ^_^
 You can also scan the qr code below or [![Donate to this project using Paypal](https://img.shields.io/badge/paypal-donate-yellow.svg)](https://www.paypal.com/paypalme/xuelongqy), donation to Author.
 
 ![](https://raw.githubusercontent.com/xuelongqy/donation/master/pay_alipay.jpg?raw=true) ![](https://raw.githubusercontent.com/xuelongqy/donation/master/pay_wxpay.jpg?raw=true) ![](https://raw.githubusercontent.com/xuelongqy/donation/master/pay_tencent.jpg?raw=true)
 
 If in donation message note name, will be record to the list if you are making open source authors, donation can leave when making project address or personal home page, a link will be added to the list have the effect of promoting each other
 
 [Donation list](https://github.com/xuelongqy/donation/blob/master/DONATIONLIST.md)
 
 ### QQ Group - 554981921
 #### Into the group of instructions
 The group is not only solve the problem of EasyreFresh, any Flutter related issues can be discussed. Just as its name, craigslist, as long as there is time, group of Lord will help you solve problems together.
