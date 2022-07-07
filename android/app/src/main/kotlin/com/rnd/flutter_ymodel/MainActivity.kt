package com.rnd.flutter_ymodel

import com.rnd.flutter_ymodel.Pigeon.*
import com.rnd.flutter_ymodel.Pigeon.YmodemRequestApi.setup
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // use methodChannel
        YModemChannel(this,flutterEngine.dartExecutor.binaryMessenger)

        // use pigeon
       // setup(flutterEngine.dartExecutor.binaryMessenger, YModemApi(this))

    }







//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        setup(getBinaryMessenger(), YModemApi(this))
//    }
}
