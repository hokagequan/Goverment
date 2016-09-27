//
//  GetCongressListReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/4.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class GetCongressListReq: HttpBaseReq {
    
    var organizationID: String? = nil
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["Org"] = organizationID as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("GetRDDBlist", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}
