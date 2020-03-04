# flutter_jscore

[![License](https://img.shields.io/badge/license-MIT-green.svg)](/LICENSE)
[![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)](https://stackoverflow.com/questions/tagged/flutter?sort=votes)
[![Pub](https://img.shields.io/badge/pub-v0.1.0-orange.svg)](https://pub.dartlang.org/packages/flutter_jscore)

JavaScriptCore for Flutter. The plugin provides the ability to evaluate JavaScript programs from within dart.

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

## JavaScriptCore

Evaluate JavaScript programs from within an app, and support JavaScript scripting of your app.

[Documentation](https://developer.apple.com/documentation/javascriptcore)

## Supported platforms

 - iOS (7.0+) 
 - macOS (10.5+) 
 - Android (arm32, arm64, x86, x86_64) 
 - Windows (coming soon) 
 - Linux (coming soon) 
 
## APIs
 
I don't think there is much to describe, flutter_jscore just makes a simple package. You can refer to the documentation of JavaScriptCore and the documentation on pub.

[JavaScriptCore](https://developer.apple.com/documentation/javascriptcore)

[flutter_jscore](https://pub.dev/documentation/flutter_jscore/latest/)
 
 ## Donation
 If you like my project, please in the upper right corner of the project "Star". Your support is my biggest encouragement! ^_^
 You can also scan the qr code below or [![Donate to this project using Paypal](https://img.shields.io/badge/paypal-donate-yellow.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=334PPRBZTY3J8&source=url), donation to Author.
 
 ![](https://raw.githubusercontent.com/xuelongqy/donation/master/pay_alipay.jpg?raw=true) ![](https://raw.githubusercontent.com/xuelongqy/donation/master/pay_wxpay.jpg?raw=true) ![](https://raw.githubusercontent.com/xuelongqy/donation/master/pay_tencent.jpg?raw=true)
 
 If in donation message note name, will be record to the list if you are making open source authors, donation can leave when making project address or personal home page, a link will be added to the list have the effect of promoting each other
 
 [Donation list](https://github.com/xuelongqy/donation/blob/master/DONATIONLIST.md)
 
 ### QQ Group - 554981921
 #### Into the group of instructions
 The group is not only solve the problem of EasyreFresh, any Flutter related issues can be discussed. Just as its name, craigslist, as long as there is time, group of Lord will help you solve problems together.