#import "FlutterDailogPlugin.h"
#if __has_include(<flutter_dailog/flutter_dailog-Swift.h>)
#import <bubbly_camera/flutter_dailog-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import <bubbly_camera/bubbly_camera-Swift.h>
#endif

@implementation FlutterDailogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterDailogPlugin registerWithRegistrar:registrar];

}
@end
