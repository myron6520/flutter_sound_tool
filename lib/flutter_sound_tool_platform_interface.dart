import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_sound_tool_method_channel.dart';

abstract class FlutterSoundToolPlatform extends PlatformInterface {
  /// Constructs a FlutterSoundToolPlatform.
  FlutterSoundToolPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterSoundToolPlatform _instance = MethodChannelFlutterSoundTool();

  /// The default instance of [FlutterSoundToolPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterSoundTool].
  static FlutterSoundToolPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterSoundToolPlatform] when
  /// they register themselves.
  static set instance(FlutterSoundToolPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
