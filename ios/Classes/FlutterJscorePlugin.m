#import "FlutterJscorePlugin.h"
#if __has_include(<flutter_jscore/flutter_jscore-Swift.h>)
#import <flutter_jscore/flutter_jscore-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_jscore-Swift.h"
#endif

@implementation FlutterJscorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterJscorePlugin registerWithRegistrar:registrar];
}
@end
