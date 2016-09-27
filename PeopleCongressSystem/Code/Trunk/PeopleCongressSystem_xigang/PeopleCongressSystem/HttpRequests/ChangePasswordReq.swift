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
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["oldPassword"] = theOld as AnyObject?
        params["newPassoword"] = theNew as AnyObject?
        params["Userid"] = PCSDataManager.defaultManager().accountManager.user!.identifier as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("UpdatePassword", nameSpace: "gonggong", params: params, completion: completion)
    }
    
}
