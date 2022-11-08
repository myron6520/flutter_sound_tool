import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_sound_tool_platform_interface.dart';

/// An implementation of [FlutterSoundToolPlatform] that uses method channels.
class MethodChannelFlutterSoundTool extends FlutterSoundToolPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_sound_tool');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
