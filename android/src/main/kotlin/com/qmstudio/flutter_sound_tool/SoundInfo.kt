package com.qmstudio.flutter_sound_tool

import android.content.res.AssetFileDescriptor

class SoundInfo(var path: String,var isAsset:Boolean) {
    var afd:AssetFileDescriptor? = null
    var duration: Long = 0
    var name: String? = null
    var bitrate: String? = null
    var mimetype: String? = null
}