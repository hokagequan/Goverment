//
//  SubmitDeviceTokenReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/6.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class SubmitDeviceTokenReq: HttpBaseReq {
    
    var deviceToken = ""

    override init() {
        super.init()
    }
    
    func requestSimpleCompletion() {
        var params = [String: String]()
        params["phoneID"] = deviceToken
        params["UserId"] = PCSDataManager.defaultManager().accountManager.user?.identifier
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["thecharset"] = "gb2312"
        
        self.request("setappENS", nameSpace: "gonggong", params: params) { (response) -> Void in
            print("")
        }
    }
    
}
