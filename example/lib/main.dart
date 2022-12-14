import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter_sound_tool/flutter_sound_tool.dart';
import 'package:flutter_sound_tool/sound_info.dart';
import 'package:flutter_sound_tool_example/a.dart';
import 'package:xmidi_player/xmidi_player.dart';

import 'package:midi_util/midi_util.dart';
import 'package:xmidi_player/xmidi_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterSoundToolPlugin = FlutterSoundTool();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    FlutterSoundTool.loadAssetSoundInfo(A.aliPay);
    loadSoundFont();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await FlutterSoundTool.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   child: GestureDetector(
              //     child: Text('?????????'),
              //     onTap: () {
              //       FlutterSoundTool.play([
              //         SoundInfo(path: A.newComm, isAsset: true),
              //       ]);
              //     },
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   child: GestureDetector(
              //     child: Text('???????????????\n'),
              //     onTap: () {
              //       FlutterSoundTool.play([
              //         SoundInfo(path: A.aliPay, isAsset: true),
              //         // SoundInfo(path: A.cashPay, isAsset: true),
              //         // SoundInfo(path: A.wxPay, isAsset: true),
              //         SoundInfo(path: A.zero, isAsset: true),
              //         SoundInfo(path: A.dian, isAsset: true),
              //         SoundInfo(path: A.zero, isAsset: true),
              //         SoundInfo(path: A.one, isAsset: true),
              //         SoundInfo(path: A.yuan, isAsset: true),
              //       ]);
              //     },
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   child: GestureDetector(
              //     child: Text('????????????\n'),
              //     onTap: () {
              //       FlutterSoundTool.play([
              //         SoundInfo(path: A.cashPay, isAsset: true, duration: 1000),
              //         // SoundInfo(path: A.cashPay, isAsset: true),
              //         // SoundInfo(path: A.wxPay, isAsset: true),
              //         SoundInfo(path: A.zero, isAsset: true),
              //         SoundInfo(path: A.dian, isAsset: true),
              //         SoundInfo(path: A.zero, isAsset: true),
              //         SoundInfo(path: A.one, isAsset: true),
              //         SoundInfo(path: A.yuan, isAsset: true),
              //       ]);
              //     },
              //   ),
              // ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   child: GestureDetector(
              //     child: Text('????????????\n'),
              //     onTap: () {
              //       FlutterSoundTool.play([
              //         SoundInfo(path: A.wxPay, isAsset: true, duration: 1000),
              //         // SoundInfo(path: A.cashPay, isAsset: true),
              //         // SoundInfo(path: A.wxPay, isAsset: true),
              //         SoundInfo(path: A.zero, isAsset: true),
              //         SoundInfo(path: A.dian, isAsset: true),
              //         SoundInfo(path: A.zero, isAsset: true),
              //         SoundInfo(path: A.one, isAsset: true),
              //         SoundInfo(path: A.yuan, isAsset: true),
              //       ]);
              //     },
              //   ),
              // ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  child: Text('??????????????????\n'),
                  onTap: () {
                    pausePer = false;
                    player.play();
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  child: Text('????????????\n'),
                  onTap: () {
                    pausePer = true;
                    player.play();
                  },
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              //   child: GestureDetector(
              //     child: Text('MIDI\n'),
              //     onTap: () {
              //       testMidi();
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  bool pausePer = false;
  late MidiPlayer player = MidiPlayer();
  late FlutterMidi flutterMidi = FlutterMidi();
  late MidiFile midiFile;
  void loadSoundFont() async {
    flutterMidi.unmute();
    flutterMidi.prepare(sf2: await rootBundle.load("assets/audio/Piano.sf2"));
    player.midiEventsStream.listen((event) {
      if (event is NoteOnEvent) {
        print("NoteOnEvent:${event.noteNumber}");
        flutterMidi.playMidiNote(midi: event.noteNumber);
        if (pausePer) {
          player.pause();
        }
      }
      if (event is NoteOffEvent) {
        print("NoteOffEvent:${event.noteNumber}");
        flutterMidi.stopMidiNote(midi: event.noteNumber);
        if (pausePer) {
          player.pause();
        }
      }
    });
    var buffer = (await rootBundle.load("assets/audio/weddingInDream.mid"))
        .buffer
        .asUint8List();
    midiFile = MidiReader().parseMidiFromBuffer(buffer);
    player.load(midiFile);
  }

  int index = 0;
  void testMidi() async {
    // flutterMidi.playMidiNote(midi: 60);

    // Open a file containing midi data

    // Construct a midi parser

// You can now access your parsed [MidiFile]
    // print("buffer:$buffer"); //MThd
    // int pos = 0;
    // String headerFlag = String.fromCharCodes(buffer, pos, pos + 4);
    // print("header:$headerFlag");
    // pos += 4;
    // int headerLen = buffer
    //     .sublist(pos, pos + 4)
    //     .buffer
    //     .asByteData()
    //     .getInt32(0, Endian.big);
    // print("headerLen:$headerLen");
    // pos += 4;
    // int fileFormat = buffer
    //     .sublist(pos, pos + 2)
    //     .buffer
    //     .asByteData()
    //     .getInt16(0, Endian.big);
    // print("fileFormat:$fileFormat");
    // pos += 2;
    // int trackNum = buffer
    //     .sublist(pos, pos + 2)
    //     .buffer
    //     .asByteData()
    //     .getInt16(0, Endian.big);
    // print("trackNum:$trackNum");
    // pos += 2;
    // //ticks dd dd ???????????????????????????dd dd ???????????????????????????0?????????ticks?????????????????????????????????4????????????ticks???1???SMPTE???????????????????????????????????????????????????SMTPE?????????????????????SMTPE??????tick??????
    // int timeType = buffer[pos] >> 7;
    // if (timeType == 0) {
    //   //ticks
    //   int ticks = (buffer[pos] & 0x7F) * (1 << 8) + buffer[pos + 1];
    //   print("ticks:$ticks");
    // }
    // if (timeType == 1) {
    //   //ticks SMTPE
    // }

    // pos += 2;
    // print("pos:$pos");
    // print("pos:${buffer[pos]}");
    // String flag = String.fromCharCodes(buffer, pos, pos + 4);
    // print("flag:$flag");
    // while (pos < buffer.length) {
    //   if (flag == "MTrk") {
    //     pos += 4;
    //     int len = buffer
    //         .sublist(pos, pos + 4)
    //         .buffer
    //         .asByteData()
    //         .getInt32(0, Endian.big);
    //     print("posLen:$len");
    //     pos += len;
    //   }
    // }

    // player.play();
    bool isEnd = true;
    midiFile.tracks.forEach((e) {
      if (index < e.length) {
        isEnd = false;
        var event = e[index];
        if (event is NoteOnEvent) {
          print("NoteOnEvent:${event.noteNumber}");
          flutterMidi.playMidiNote(midi: event.noteNumber);
        }
        if (event is NoteOffEvent) {
          print("NoteOffEvent:${event.noteNumber}");
          flutterMidi.stopMidiNote(midi: event.noteNumber);
        }
      }
    });
    if (isEnd) {
      index = -1;
    }
    index++;
  }
}
