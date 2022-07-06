//
//  YModemChannel.swift
//  Runner
//
//  Created by RND on 2022/7/6.
//

import Foundation
import Flutter

public class YModemChannel{

    private var operateManager = OperateManager()

    var count =  0
    var channel:FlutterMethodChannel
    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "com.flutter.guide.YModemChannel", binaryMessenger: messenger)
        channel.setMethodCallHandler{ (call:FlutterMethodCall, result:@escaping FlutterResult) in
            // stop Ota upgrade
            if (call.method == "otaStop") {
                if let dict = call.arguments as? Dictionary<String, Any> {
                    let stop = dict["isStop"] as? Bool ?? false
                    if stop {
                        self.operateManager.stopOta{
                            args in
                            // send data to flutter
                            self.channel.invokeMethod("args", arguments: args)
                        }
                    }
                }
            }
            
            // begin init
            if call.method == "otaBegin" {
                self.operateManager.initData()
                
            }
            
            
            // receive once data 0x05 tips: 0x05 only for your own projects
            // send data start
            if call.method == "otaStart" {
                if let dict = call.arguments as? Dictionary<String,Any>{
                    
                    // receive flutter channel data
                    
                    // file name
                    let fileNames:String = dict["fileName"] as? String ?? ""
                    
                    // file path
                    let filePath: String = dict["filePath"] as? String ?? ""
                    
                    // ota status
                    let otaStatus:String = dict["otaStatus"] as? String ?? ""
                    
                    self.operateManager.updateOta(fileNames: fileNames,filePaths: filePath, otaState: otaStatus){
                        args in
                        if otaStatus == OTAC || otaStatus == OTASTART || otaStatus == OTAACK || otaStatus == OTANAK{
                            // send data to flutter
                            self.channel.invokeMethod("args", arguments: args)
                        }
                    }
                }
            }
        }
    }
}
