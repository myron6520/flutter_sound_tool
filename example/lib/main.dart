import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_sound_tool/flutter_sound_tool.dart';
import 'package:flutter_sound_tool/sound_info.dart';
import 'package:flutter_sound_tool_example/a.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}
