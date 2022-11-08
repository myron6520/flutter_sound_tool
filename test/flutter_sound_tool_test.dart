import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sound_tool/flutter_sound_tool.dart';
import 'package:flutter_sound_tool/flutter_sound_tool_platform_interface.dart';
import 'package:flutter_sound_tool/flutter_sound_tool_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterSoundToolPlatform
    with MockPlatformInterfaceMixin
    implements FlutterSoundToolPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterSoundToolPlatform initialPlatform = FlutterSoundToolPlatform.instance;

  test('$MethodChannelFlutterSoundTool is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterSoundTool>());
  });

  test('getPlatformVersion', () async {
    FlutterSoundTool flutterSoundToolPlugin = FlutterSoundTool();
    MockFlutterSoundToolPlatform fakePlatform = MockFlutterSoundToolPlatform();
    FlutterSoundToolPlatform.instance = fakePlatform;

    expect(await flutterSoundToolPlugin.getPlatformVersion(), '42');
  });
}
