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
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["huodongId"] = activityID
        params["userList"] = qrCodes.joinWithSeparator(",")
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "utf-8"
        
        self.request("HuoDongAddCheckIn", nameSpace: "GetRDDBlist", params: params, completion: completion)
    }
    
}