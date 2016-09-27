//
//  DeleteVariableReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/17.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class DeleteVariableReq: HttpBaseReq {
    
    var variable: Variable = Variable()
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(_ completion: SimpleCompletion?) {
        var params = [String: AnyObject]()
        params["lvzhi_guid"] = variable.token as AnyObject?
//        params["AddUser"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("LvZhiDel", nameSpace: "rendadaibiao", params: params) { (response) -> Void in
            let result = response?.result
            
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    completion?(true, "删除成功", errorCode)
                }
                else {
                    completion?(false, "删除失败", errorCode)
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                guard let responseString = HttpBaseReq.parseResponse(value) as? String else {
                    return
                }
                
                if ((responseString as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    errorCode = responseString
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }

}
