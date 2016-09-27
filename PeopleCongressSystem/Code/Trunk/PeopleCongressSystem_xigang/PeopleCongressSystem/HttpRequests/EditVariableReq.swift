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
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: Any]()
        params["Lvzhi_guid"] = variable.identifier
        params["Title"] = variable.title
        params["type"] = variable.type
        params["content"] = variable.content
        params["remark"] = variable.remark
        params["IsPost"] = variable.submitted ? "1" : "0"
        params["Lvzhi_cyr"] = variable.persons
        params["Lvzhi_time"] = variable.createTime
        params["AddUser"] = PCSDataManager.defaultManager().accountManager.user!.congressID
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("LvZhiMod", nameSpace: "rendadaibiao", params: params, completion: completion)
    }
    
    func requestSimpleCompletion(_ completion: SimpleCompletion?) {
        var params = [String: Any]()
        params["lvzhi_guid"] = variable.token
        params["Title"] = variable.title
        params["Type"] = variable.type
        params["content"] = variable.content
        params["remark"] = variable.remark
        params["IsPost"] = variable.submitted ? "1" : "0"
        params["lvzhi_cyr"] = variable.persons
        params["lvzhi_Time"] = variable.createTime
        params["AddUser"] = PCSDataManager.defaultManager().accountManager.user!.congressID
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        params["shouming"] = ""
        
        self.request("LvZhiMod", nameSpace: "rendadaibiao", params: params) { (response) -> Void in
            let result = response?.result
            
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    completion?(true, nil, errorCode)
                }
                else {
                    completion?(false, "修改失败，请检查您的网络状况", errorCode)
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
