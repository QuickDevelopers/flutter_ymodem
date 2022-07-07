//
//  OperateManager.swift
//  Runner
//
//  Created by RND on 2022/7/7.
//

import Cocoa

import FlutterMacOS

class OperateManager: NSObject, YModemUtilDelegate{
    
    //Status代码
    private var orderStatus:Int?
    
    // please you update project device max size
    private var ymodemUtil = YModemUtil.init(1024)
    
    override init() {
        super.init()
        ymodemUtil?.delegate = self
        //开始初始化
        ymodemUtil?.initBegin()
    }
    
    func initData(){
        //开始初始化
        ymodemUtil?.initBegin();
    }
    
    func updateOta(fileNames:String,filePaths:String,otaState:String, complete: @escaping (_ args: Any) -> Void) {
        
        if otaState != ""{
            if otaState == OTAC{
                self.orderStatus = Int(OrderStatusC.rawValue)
            }else if otaState == OTASTART{
                self.orderStatus = Int(OrderStatusFirst.rawValue)
            }else if otaState == OTAACK{
                self.orderStatus = Int(OrderStatusACK.rawValue)
            }else if otaState == OTANAK{
                self.orderStatus = Int(OrderStatusNAK.rawValue)
            }
            
            var arg:[String: Any] = [:]
            
            self.ymodemUtil?.setFirmwareHandleOTADataWith(OrderStatus(rawValue: OrderStatus.RawValue(self.orderStatus!)), fileName: fileNames, filePath:filePaths){
                current, total, msg, data in
                // 返回数据
                arg = ["current":current,"total":total,"msg":msg! as String,"data":data as Any]
                complete(arg)
            }
        }
    }
    
    func onWriteBleData(_ data: Data!) {
        // 发送数据
        print("data is: \(String(describing: data))")
    }
    
    
    func stopOta(complete: @escaping (_ args: Any) -> Void){
        var arg:[String: Any] = [:]
        self.ymodemUtil?.stopUpgrade{
            current, total, msg, data in
            // 返回数据
            arg = ["current":current,"total":total,"msg":msg! as String,"data":data as Any]
            complete(arg)
        }
    }
}


