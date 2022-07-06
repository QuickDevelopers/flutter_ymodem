package com.rnd.flutter_ymodel

import android.content.Context
import com.bw.yml.YModem
import com.bw.yml.YModemListener


/**
 * created by ArdWang 2022/7/6:3:38 下午
 */
class OperateManager {

    private lateinit var yModem: YModem


    fun start(context: Context, filepath: String, filename: String,md5:String,size:Int, param: OperateInterface){

        var datak :ByteArray = byteArrayOf()
        var currentk = 0
        var totalk = 0
        var msgk = ""

        yModem = YModem.Builder()
            .with(context)
            .filePath(filepath)
            .fileName(filename)
            .checkMd5(md5)
            .sendSize(size)
            .callback(object : YModemListener {
                override fun onDataReady(data: ByteArray) {
                    datak = data
                    param.updateOta(currentk,totalk,msgk,datak)
                }

                override fun onProgress(currentSent: Int, total: Int) {
                    //val currentPt = currentSent.toFloat() / total
                    //val a = (currentPt * 100).toInt()
                    currentk = currentSent
                    totalk = total
                    param.updateOta(currentk,totalk,msgk,datak)

                }

                override fun onSuccess() {
                    param.updateOta(currentk,totalk,msgk,datak)
                }

                override fun onFailed(reason: String) {
                    msgk = reason
                    param.updateOta(currentk,totalk,msgk,datak)
                }
            }).build()
        yModem.start()
    }


    fun stop(){
        yModem.stop()
    }

}