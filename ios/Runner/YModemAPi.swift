//
//  YModemAPi.swift
//  Runner
//
//  Created by RND on 2022/7/7.
//

import Foundation
import Flutter


class YModemAPi: NSObject, YmodemRequestApi{
    
    // 操作类
    private var operateManager = OperateManager()
    
    func getMessage(params: YmodemResponse) -> YmodemRequest {
        
        var result = YmodemRequest()
        
        let filename = params.filename
        let filepath = params.filepath
        let status = params.status
        //let start = params.start
        let stop = params.stop
        let operate = params.operate
        
        if status != nil {
            
            if status == "otaStop" {
                if stop {
                    self.operateManager.stopOta{
                        args in
                        result.current = args["current"]
                        result.total = args["total"]
                        result.data = args["data"]
                        result.msg = args["msg"]
                    }
                }
            }
            
            if status == "otaBegin" {
                self.operateManager.initData()
            }
            
            if status == "otaStart" {
                if filename != nil && filepath != nil && operate != nil {
                    self.operateManager.updateOta(fileNames: filename, filePaths: filepath, otaState: operate){
                        args in
                        if operate == OTAC || operate == OTASTART || operate == OTAACK || operate == OTANAK{
                            
                            result.current = args["current"]
                            result.total = args["total"]
                            result.data = args["data"]
                            result.msg = args["msg"]
                            
                        }
                    }
                }
            }
        }
        
        return result
    }
    
}
