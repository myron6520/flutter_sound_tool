import 'package:flutter/foundation.dart';

class MidiFile {
  final Uint8List bytes;
  final String fileName;

  MidiFile(this.bytes, this.fileName) {
    parse();
  }
  void parse() {
    late String id;
    late int len;
  }
}
