package com.qmstudio.flutter_sound_tool

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.SoundPool
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.util.*
import kotlin.concurrent.timerTask

class SoundTool(var context: Context) {
    private val soundQueue:MutableList<SoundInfo> = mutableListOf()
    private val soundPool: SoundPool by lazy {
        val pool = SoundPool.Builder()
            .setMaxStreams(10)
            .setAudioAttributes(
                AudioAttributes.Builder()
                    .setLegacyStreamType(AudioManager.STREAM_MUSIC)
                    .build()
            )
            .build()
        pool.setOnLoadCompleteListener { soundPool, sampleId, status ->
            if(status == 0){
                soundPool.play(sampleId,1f,1f,1,0,1.0f)
            }

            Timer().schedule(timerTask { play() },currentDuration)
        }
        return@lazy pool
    }
    private var currentDuration:Long = 0
    private var isPlaying:Boolean = false
    private var soundId:Int = 0
    private fun play(){
        if (soundQueue.isNotEmpty()){
            isPlaying = true
            val current = soundQueue.first()
            Log.e("SoundTool", "play: ${current.path}")
            currentDuration = current.duration
            val file = File(current.path)
            soundId = if(current.isAsset){
                soundPool.load(current.afd,1)
            }else{
                soundPool.load(current.path,1)
            }
            soundQueue.removeFirst()
        }else{
            isPlaying = false
        }
    }
    private fun tryToPlay(){
        if(isPlaying){
            return
        }
        Timer().schedule(timerTask { play() },0)
    }
    public fun push(sounds:List<SoundInfo>){
        soundQueue.addAll(sounds)
        tryToPlay()
    }
}