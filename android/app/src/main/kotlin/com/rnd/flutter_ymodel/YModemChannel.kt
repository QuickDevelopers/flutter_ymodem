package com.rnd.flutter_ymodel

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * created by ArdWang 2022/7/6:3:38 下午
 */
class YModemChannel (context: Context,message: BinaryMessenger): MethodChannel.MethodCallHandler{

    private var channel: MethodChannel

    private var context: Context

    private var operateManager: OperateManager


    init {
        channel = MethodChannel(message, "com.flutter.guide.MethodChannel")
        channel.setMethodCallHandler(this)
        this.context = context
        operateManager = OperateManager()
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        // stop ota upgrade
        if(call.method == "otaStop"){
            val stop = call.argument("isStop") as Boolean?
            if(stop == true){
                operateManager.stop()
            }
        }

        if(call.method == "otaBegin"){

        }

        // receive once data 0x05
        // send data start
        if(call.method == "otaStart"){
            // receive filename
            val filename = call.argument("fileName") as String?
            val filepath = call.argument("filePath") as String?

            val otaStatus = call.argument("otaStatus") as String?

            if (filename != null && filepath != null) {
                // change you size
               operateManager.start(context,filepath,filename,"",1024,object : OperateInterface {
                   override fun updateOta(current: Int, total: Int, msg: String, data: ByteArray) {
                       if(otaStatus == "43" || otaStatus == "0643" || otaStatus == "06" || otaStatus == "15"){
                           // combine package
                           var args = mapOf("current" to current,"total" to total, "msg" to msg, "data" to data)
                           channel.invokeMethod("args", args)
                       }
                   }
               })
            }
        }
    }


}


