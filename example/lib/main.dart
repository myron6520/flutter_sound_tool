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
// import 'package:midi_util/midi_util.dart';
// import 'package:xmidi_player/xmidi_player.dart';

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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  child: Text('新商品'),
                  onTap: () {
                    FlutterSoundTool.play([
                      SoundInfo(path: A.newComm, isAsset: true),
                    ]);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  child: Text('支付宝收款\n'),
                  onTap: () {
                    FlutterSoundTool.play([
                      SoundInfo(path: A.aliPay, isAsset: true),
                      // SoundInfo(path: A.cashPay, isAsset: true),
                      // SoundInfo(path: A.wxPay, isAsset: true),
                      SoundInfo(path: A.zero, isAsset: true),
                      SoundInfo(path: A.dian, isAsset: true),
                      SoundInfo(path: A.zero, isAsset: true),
                      SoundInfo(path: A.one, isAsset: true),
                      SoundInfo(path: A.yuan, isAsset: true),
                    ]);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  child: Text('现金收款\n'),
                  onTap: () {
                    FlutterSoundTool.play([
                      SoundInfo(path: A.cashPay, isAsset: true, duration: 1000),
                      // SoundInfo(path: A.cashPay, isAsset: true),
                      // SoundInfo(path: A.wxPay, isAsset: true),
                      SoundInfo(path: A.zero, isAsset: true),
                      SoundInfo(path: A.dian, isAsset: true),
                      SoundInfo(path: A.zero, isAsset: true),
                      SoundInfo(path: A.one, isAsset: true),
                      SoundInfo(path: A.yuan, isAsset: true),
                    ]);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  child: Text('微信收款\n'),
                  onTap: () {
                    FlutterSoundTool.play([
                      SoundInfo(path: A.wxPay, isAsset: true, duration: 1000),
                      // SoundInfo(path: A.cashPay, isAsset: true),
                      // SoundInfo(path: A.wxPay, isAsset: true),
                      SoundInfo(path: A.zero, isAsset: true),
                      SoundInfo(path: A.dian, isAsset: true),
                      SoundInfo(path: A.zero, isAsset: true),
                      SoundInfo(path: A.one, isAsset: true),
                      SoundInfo(path: A.yuan, isAsset: true),
                    ]);
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GestureDetector(
                  child: Text('MIDI\n'),
                  onTap: () {
                    testMidi();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // late MidiPlayer player = MidiPlayer();
  late FlutterMidi flutterMidi = FlutterMidi();
  void loadSoundFont() async {
    flutterMidi.unmute();
    flutterMidi.prepare(sf2: await rootBundle.load("assets/audio/Piano.sf2"));
  }

  void testMidi() async {
    flutterMidi.playMidiNote(midi: 60);

    // player.midiEventsStream.listen((event) {
    //   if (event is NoteOnEvent) {
    //     print("NoteOnEvent:${event.noteNumber}");
    //     flutterMidi.playMidiNote(midi: event.noteNumber);
    //   }
    //   if (event is NoteOffEvent) {
    //     print("NoteOffEvent:${event.noteNumber}");
    //     flutterMidi.stopMidiNote(midi: event.noteNumber);
    //   }
    // });

    var buffer =
        (await rootBundle.load("assets/audio/Bach__Invention_No._13.mid"))
            .buffer
            .asInt8List();
    print("buffer:$buffer"); //MThd
    int pos = 0;
    String headerFlag = String.fromCharCodes(buffer, pos, pos + 4);
    print("header:$headerFlag");
    pos += 4;
    int headerLen = buffer
        .sublist(pos, pos + 4)
        .buffer
        .asByteData()
        .getInt32(0, Endian.big);
    print("headerLen:$headerLen");
    pos += 4;
    int fileFormat = buffer
        .sublist(pos, pos + 2)
        .buffer
        .asByteData()
        .getInt16(0, Endian.big);
    print("fileFormat:$fileFormat");
    pos += 2;
    int trackNum = buffer
        .sublist(pos, pos + 2)
        .buffer
        .asByteData()
        .getInt16(0, Endian.big);
    print("trackNum:$trackNum");
    pos += 2;
    //ticks dd dd 指定基本时间格式，dd dd 的最高位为标记位，0为采用ticks计时，后面的数据为一个4分音符的ticks；1为SMPTE格式计时，后面的数值则是定义每秒中SMTPE帧的数量及每个SMTPE帧的tick。用
    int timeType = buffer[pos] >> 7;
    if (timeType == 0) {
      //ticks
      int ticks = (buffer[pos] & 0x7F) * (1 << 8) + buffer[pos + 1];
      print("ticks:$ticks");
    }
    if (timeType == 1) {
      //ticks SMTPE
    }

    pos += 2;
    print("pos:$pos");
    print("pos:${buffer[pos]}");
    String flag = String.fromCharCodes(buffer, pos, pos + 4);
    print("flag:$flag");
    while (pos < buffer.length) {
      if (flag == "MTrk") {
        pos += 4;
        int len = buffer
            .sublist(pos, pos + 4)
            .buffer
            .asByteData()
            .getInt32(0, Endian.big);
        print("posLen:$len");
        pos += len;
      }
    }

    // MidiFile file = MidiReader().parseMidiFromBuffer(buffer);
    // print("object:${file.tracks}");
    // file.tracks.forEach((e) {
    //   print("event:${e.length}");
    // });
    // player.load(file);
    // player.play();
  }
}
