//
//  GetGroupReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class GetGroupReq: HttpBaseReq {
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["user_ID"] = PCSDataManager.defaultManager().accountManager.user!.identifier as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("GetOrg", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}
