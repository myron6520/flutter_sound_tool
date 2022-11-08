import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_sound_tool/flutter_sound_tool_method_channel.dart';

void main() {
  MethodChannelFlutterSoundTool platform = MethodChannelFlutterSoundTool();
  const MethodChannel channel = MethodChannel('flutter_sound_tool');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
