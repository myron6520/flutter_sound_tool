class SoundInfo {
  final String path;
  final bool isAsset;
  final int duration;

  SoundInfo({required this.path, required this.isAsset, this.duration = 0});
  String? name;
  String? bitrate;
  String? mimetype;
}
