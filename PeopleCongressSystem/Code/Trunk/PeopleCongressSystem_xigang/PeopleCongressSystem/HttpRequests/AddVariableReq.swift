//
//  AddVariableReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/14.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class AddVariableReq: HttpBaseReq {
    
    var variable: Variable = Variable()
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: Any]()
        params["lvzhi_guid"] = variable.token
        params["Title"] = variable.title
        params["Type"] = variable.type
        params["content"] = variable.content
        params["remark"] = variable.remark
        params["IsPost"] = (variable.submitted ? "1" : "0")
        params["lvzhi_cyr"] = variable.persons
        params["lvzhi_Time"] = variable.createTime
        params["AddUser"] = PCSDataManager.defaultManager().accountManager.user!.congressID
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["shouming"] = ""
        params["thecharset"] = "gb2312"
        
        self.request("LvZhiAdd", nameSpace: "rendadaibiao", params: params, completion: completion)
    }

}
