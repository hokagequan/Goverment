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
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["Org"] = organizationID
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "utf-8"
        
        self.request("GethuodongUserlist", params: params, completion: completion)
    }
    
}