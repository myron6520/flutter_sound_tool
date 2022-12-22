import 'package:flutter/foundation.dart';

class MidiFileReader {
  final Uint8List bytes;
  int _pos = 0;
  MidiFileReader(this.bytes) {
    _pos = 0;
  }
  bool canRead(int amount) {
    return _pos + amount < bytes.length;
  }
}
