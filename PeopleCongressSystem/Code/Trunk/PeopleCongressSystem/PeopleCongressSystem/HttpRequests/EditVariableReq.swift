//
//  EditVariableReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/17.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class EditVariableReq: HttpBaseReq {

    var variable: Variable = Variable()
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["Lvzhi_guid"] = variable.identifier
        params["Title"] = variable.title
        params["type"] = variable.type
        params["content"] = variable.content
        params["remark"] = variable.remark
        params["IsPost"] = variable.submitted ? "1" : "0"
        params["Lvzhi_cyr"] = variable.persons
        params["Lvzhi_time"] = variable.createTime
        params["AddUser"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("LvZhiMod", nameSpace: "rendadaibiao", params: params, completion: completion)
    }
    
    func requestSimpleCompletion(completion: SimpleCompletion?) {
        var params = [String: AnyObject]()
        params["Lvzhi_guid"] = variable.identifier
        params["Title"] = variable.title
        params["type"] = variable.type
        params["content"] = variable.content
        params["remark"] = variable.remark
        params["IsPost"] = variable.submitted ? "1" : "0"
        params["Lvzhi_cyr"] = variable.persons
        params["Lvzhi_time"] = variable.createTime
        params["AddUser"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("LvZhiMod", nameSpace: "rendadaibiao", params: params) { (response) -> Void in
            let result = response?.result
            
            var success: Bool = false
            
            defer {
                if success == true {
                    completion?(true, "修改成功")
                }
                else {
                    completion?(false, "修改失败")
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
