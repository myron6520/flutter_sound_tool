package com.qmstudio.flutter_sound_tool_example

import android.os.Bundle
import android.util.Log
import com.leff.midi.MidiFile
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.e("MainActivity", "onCreate", )
        val input = assets.open("kuangxiangqu.mid")
        val file = MidiFile(input)
        file.tracks.forEach { track ->
            Log.e("MainActivity", "eventLen:${track.events.size}", )
            track.events.forEach { event ->
                Log.e("MainActivity", "event:${event.javaClass}", )
            }
        }
    }
}
