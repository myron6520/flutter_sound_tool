import 'package:flutter/services.dart';
import 'package:flutter_sound_tool/sound_info.dart';

class FlutterSoundTool {
  static const methodChannel = MethodChannel('flutter_sound_tool');
  static Future<String?> getPlatformVersion() =>
      methodChannel.invokeMethod<String>('getPlatformVersion');

  static Future<void> loadAssetSoundInfo(String asset) async {
    methodChannel
        .invokeMethod<void>('loadSoundInfo', {"path": asset, "isAsset": true});
  }

  static Future<void> play(List<SoundInfo> infos) async {
    methodChannel.invokeMethod<void>(
      'play',
      infos.map((e) => {"path": e.path, "isAsset": e.isAsset}).toList(),
    );
  }
}
