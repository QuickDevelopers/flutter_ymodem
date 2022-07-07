package com.rnd.flutter_ymodel

import android.content.Context
import io.flutter.embedding.engine.FlutterEngine


/**
 * created by ArdWang 2022/7/7:4:32 下午
 */
class YModemApi(context: Context): Pigeon.YmodemRequestApi {

    private var context: Context

    private var operateManager: OperateManager

    init {
        this.context = context
        operateManager = OperateManager()
    }

    override fun getMessage(params: Pigeon.YmodemResponse): Pigeon.YmodemRequest {

        val result = Pigeon.YmodemRequest()

        val filename = params.filename
        val filepath = params.filepath
        val status = params.status
        //val start = params.start
        val stop = params.stop
        val operate = params.operate

        if (status != null){
            if(status == "otaStop"){
                if (stop == true){
                    operateManager.stop()
                }
            }
        }

        if(status == "otaBegin"){
            //
        }

        if(status == "otaStart"){
            if(filename != null && filepath != null && operate != null){
                operateManager.start(context,filepath,filename,"",1024,object : OperateInterface {
                    override fun updateOta(current: Int, total: Int, msg: String, data: ByteArray) {
                        if(operate == "43" || operate == "0643" || operate == "06" || operate == "15"){
                            // combine package
                            //var args = mapOf("current" to current,"total" to total, "msg" to msg, "data" to data)
                            result.current = current.toLong()
                            result.total = total.toLong()
                            result.msg = msg
                            result.data = data.toList()
                        }
                    }
                })
            }
        }

        return result

    }



}