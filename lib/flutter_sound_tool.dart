
import 'flutter_sound_tool_platform_interface.dart';

class FlutterSoundTool {
  Future<String?> getPlatformVersion() {
    return FlutterSoundToolPlatform.instance.getPlatformVersion();
  }
}
