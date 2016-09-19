//
//  GetActivitiesReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class GetActivitiesReq: HttpBaseReq {
    
    var type: String? = nil
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["user_ID"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["huodonglx"] = type
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("Gethuodonglist", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}