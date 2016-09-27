//
//  FeedbackReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class FeedbackReq: HttpBaseReq {
    var message: String? = nil
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["yijianneirong"] = message as AnyObject?
        params["Userid"] = PCSDataManager.defaultManager().accountManager.user!.identifier as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("yijianfankui", nameSpace: "gonggong", params: params, completion: completion)
    }
    
}
