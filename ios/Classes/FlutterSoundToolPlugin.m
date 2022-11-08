#import "FlutterSoundToolPlugin.h"
#if __has_include(<flutter_sound_tool/flutter_sound_tool-Swift.h>)
#import <flutter_sound_tool/flutter_sound_tool-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_sound_tool-Swift.h"
#endif

@implementation FlutterSoundToolPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSoundToolPlugin registerWithRegistrar:registrar];
}
@end
