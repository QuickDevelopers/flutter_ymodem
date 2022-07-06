package com.rnd.flutter_ymodel

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        YModemChannel(this,flutterEngine.dartExecutor.binaryMessenger)
       // flutterEngine.plugins.add(MyPlugin())
    }
}
