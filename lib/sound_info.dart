import 'dart:ffi';

class SoundInfo {
  final String path;
  final bool isAsset;

  SoundInfo({required this.path, required this.isAsset});
  int duration = 0;
  String? name;
  String? bitrate;
  String? mimetype;
}
