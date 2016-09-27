//
//  GetPersonListReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/4.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class GetPersonListReq: HttpBaseReq {
    
    var activityID: String? = nil
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["huodongId"] = activityID as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("GethuodongUserlist", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}
