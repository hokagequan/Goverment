//
//  FeedbackReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class FeedbackReq: HttpBaseReq {
    // TODO: 接口实现
    var message: String? = nil
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["oldPassword"] = message
        params["Userid"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "utf-8"
        
        self.request("UpdatePassword", params: params, completion: completion)
    }
    
}
