//
//  OperateManager.swift
//  Runner
//
//  Created by RND on 2022/7/6.
//

import UIKit
import Flutter

class OperateManager: NSObject, YModemUtilDelegate{
    
    //Status code
    private var orderStatus:Int?
    
    private var ymodemUtil = YModemUtil.init(256)
    
    override init() {
        super.init()
        ymodemUtil?.delegate = self
    }
    
    func initData(){
        //begin init
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
                // return to fltter code
                arg = ["current":current,"total":total,"msg":msg! as String,"data":data as Any]
                complete(arg)
            }
        }
    }
    
    func onWriteBleData(_ data: Data!) {
        // send data
        print("data is: \(String(describing: data))")
    }
    
    
    func stopOta(complete: @escaping (_ args: Any) -> Void){
        var arg:[String: Any] = [:]
        self.ymodemUtil?.stopUpgrade{
            current, total, msg, data in
            // // return to fltter code
            arg = ["current":current,"total":total,"msg":msg! as String,"data":data as Any]
            complete(arg)
        }
    }
}

