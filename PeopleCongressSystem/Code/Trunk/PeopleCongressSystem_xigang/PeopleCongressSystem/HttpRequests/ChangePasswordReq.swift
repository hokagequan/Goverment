//
//  ChangePasswordReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/8.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class ChangePasswordReq: HttpBaseReq {

    var theOld: String? = nil
    var theNew: String? = nil
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["oldPassword"] = theOld
        params["newPassoword"] = theNew
        params["Userid"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("UpdatePassword", nameSpace: "gonggong", params: params, completion: completion)
    }
    
}
