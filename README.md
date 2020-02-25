# flutter_jscore

[![License](https://img.shields.io/badge/license-MIT-green.svg)](/LICENSE)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://stackoverflow.com/questions/tagged/flutter?sort=votes)
[![Pub](https://img.shields.io/badge/pub-v0.0.1-orange.svg)](https://pub.dartlang.org/packages/flutter_easyrefresh)

JavaScriptCore for Flutter.

## Getting Started

#### Add dependency
```
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

#### Super simple to use
```
import 'package:flutter_jscore/flutter_jscore.dart';

void runJS() {
    JSContext jsContext = JSContext.createInGroup();
    // Replace '1 + 1' with your JavaScript code
    JSValue jsValue = jsContext.evaluate('1 + 1');
    print(jsValue.string);
    jsContext.release();
}
```