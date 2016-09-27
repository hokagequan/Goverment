//
//  CheckInReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/7.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class CheckInReq: HttpBaseReq {
    
    var activityID: String? = nil
    var qrCodes = [String]()
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["huodongId"] = activityID as AnyObject?
        params["userList"] = qrCodes.joined(separator: ",") as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("HuoDongAddCheckIn", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}
