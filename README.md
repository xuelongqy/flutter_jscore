# flutter_jscore

[![License](https://img.shields.io/badge/license-MIT-green.svg)](/LICENSE)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://stackoverflow.com/questions/tagged/flutter?sort=votes)
[![Pub](https://img.shields.io/badge/pub-v0.0.1-orange.svg)](https://pub.dartlang.org/packages/flutter_easyrefresh)

JavaScriptCore for Flutter.

#### Demo
|Screen recording|Apk|
|:---:|:---:|
|![](https://raw.githubusercontent.com/xuelongqy/flutter_jscore/master/example/art/flutter_jscore.gif)|![](https://raw.githubusercontent.com/xuelongqy/flutter_jscore/master/example/art/apk_QRCode.png)|
|[Code](https://github.com/xuelongqy/flutter_jscore/blob/master/example/lib/views/jscore_page.dart)|[Download](https://raw.githubusercontent.com/xuelongqy/flutter_jscore/master/example/art/flutter_jscore.apk)|

## Getting Started

#### Add dependency
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

#### Super simple to use
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

