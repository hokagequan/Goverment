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
        params["thecharset"] = "utf-8"
        
        self.request("LvZhiAdd", nameSpace: "rendadaibiao", params: params, completion: completion)
    }

}
