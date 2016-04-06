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
    
    func requestSimpleCompletion(completion: SimpleCompletion?) {
        var params = [String: AnyObject]()
        params["lvzhi_guid"] = variable.token
//        params["AddUser"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("LvZhiDel", nameSpace: "rendadaibiao", params: params) { (response) -> Void in
            let result = response?.result
            
            var success: Bool = false
            
            defer {
                if success == true {
                    completion?(true, "删除成功")
                }
                else {
                    completion?(false, "删除失败")
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                if ((value as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }

}
