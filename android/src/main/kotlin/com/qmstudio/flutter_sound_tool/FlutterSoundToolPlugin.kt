package com.qmstudio.flutter_sound_tool

import android.content.Context
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaMetadataRetriever
import android.media.SoundPool
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors


/** FlutterSoundToolPlugin */
class FlutterSoundToolPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var applicationContext: Context
  private var service: ExecutorService = Executors.newCachedThreadPool()
    private val soundTool: SoundTool by lazy {
        SoundTool(applicationContext)
    }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_sound_tool")
    channel.setMethodCallHandler(this)
      applicationContext =  flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
      Log.e("FlutterSoundToolPlugin", "onMethodCall: ${call.method}", )
      Log.e("FlutterSoundToolPlugin", "onMethodCall: ${call.arguments}", )
      when(call.method){
          "getPlatformVersion"->result.success("Android ${android.os.Build.VERSION.RELEASE}")
          "loadSoundInfo"->{
              val arguments = call.arguments as Map<Any,Any>
              val path = "${arguments["path"]}"
              val isAsset = "${arguments["isAsset"]}".toBoolean()
              val duration = "${arguments["duration"]}".toLongOrNull() ?: 0
              service.execute {  loadSoundInfo(path,isAsset,duration)}
          }
          "play"->{
              val arguments = call.arguments as List<Any>?
              if(arguments?.isNotEmpty() == true){
                  service.execute {
                      val list = mutableListOf<SoundInfo>()
                      for (el in arguments){
                          val info = el as Map<Any,Any>
                          val path = "${info["path"]}"
                          val isAsset = "${info["isAsset"]}".toBoolean()
                          val duration = "${info["duration"]}".toLongOrNull() ?: 0
                          val soundInfo = loadSoundInfo(path,isAsset,duration)
                          list.add(soundInfo)
                      }
                      Log.e("FlutterSoundToolPlugin", "onMethodCall: $list", )
                      soundTool.push(list)
                  }
              }

          }
          else ->result.notImplemented()
      }

  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

    private fun getAssetFilePath(assetPath:String): String {
        val loader = FlutterInjector.instance().flutterLoader()
        return loader.getLookupKeyForAsset(assetPath)
    }
    private val cachedInfos = mutableMapOf<String,SoundInfo>()
    private fun loadSoundInfo(path:String, isAsset:Boolean,durationMs:Long):SoundInfo{
        val cached = cachedInfos[path]
        return if(cached != null)  cached else{
            val metadataRetriever = MediaMetadataRetriever()
            val info = SoundInfo(path,isAsset)
            if(isAsset){
                val assetPath = getAssetFilePath(path)
                val afd = applicationContext.assets.openFd(assetPath)
                info.afd = afd
                metadataRetriever.setDataSource(afd.fileDescriptor,afd.startOffset,afd.length)
            }else{
                metadataRetriever.setDataSource(path)
            }
            val duration = if(durationMs>0) durationMs else metadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)?.toLongOrNull() ?: 0
            val name = metadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE)
            val mimetype = metadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE)
            val bitrate = metadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_BITRATE)
            info.duration = duration
            info.name = name
            info.mimetype = mimetype
            info.bitrate = bitrate
            cachedInfos.put(path,info)
            Log.e("FlutterSoundToolPlugin", "onMethodCall: ${info.duration}", )
            return  info
        }

    }
}


