//
//  YModemChannel.swift
//  Runner
//
//  Created by RND on 2022/7/7.
//

import Foundation
import FlutterMacOS

public class YModemChannel{
    // 操作类
    private var operateManager = OperateManager()
    
    var count =  0
    var channel:FlutterMethodChannel
    init(messenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "com.flutter.guide.YModemChannel", binaryMessenger: messenger)
        channel.setMethodCallHandler{ (call:FlutterMethodCall, result:@escaping FlutterResult) in
            // 停止Ota升级
            if (call.method == "otaStop") {
                if let dict = call.arguments as? Dictionary<String, Any> {
                    let stop = dict["isStop"] as? Bool ?? false
                    if stop {
                        self.operateManager.stopOta{
                            args in
                            // 传送数据到flutter端
                            self.channel.invokeMethod("args", arguments: args)
                        }
                    }
                }
            }
            
            // 开始 全部清空 重置
            if call.method == "otaBegin" {
                self.operateManager.initData()
            }
            // 接收到发送的数据 0x05
            // 发送数据开始
            if call.method == "otaStart" {
                if let dict = call.arguments as? Dictionary<String,Any>{
                    // 接收flutter传过来的数据
                    let fileNames:String = dict["fileName"] as? String ?? ""
                    
                    let filePath: String = dict["filePath"] as? String ?? ""
                    
                    let otaStatus:String = dict["otaStatus"] as? String ?? ""
                    
                    self.operateManager.updateOta(fileNames: fileNames,filePaths: filePath, otaState: otaStatus){
                        args in
                        if otaStatus == OTAC || otaStatus == OTASTART || otaStatus == OTAACK || otaStatus == OTANAK{
                            // 传送数据到flutter端
                            self.channel.invokeMethod("args", arguments: args)
                        }
                    }
                }
            }
        }
    }
}
