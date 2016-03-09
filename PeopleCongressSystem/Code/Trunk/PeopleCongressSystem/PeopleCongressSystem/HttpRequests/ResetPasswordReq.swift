//
//  ResetPasswordReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class ResetPasswordReq: HttpBaseReq {
    
    var name: String? = nil
    var tel: String? = nil
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["rddb_name"] = name
        params["rddb_phone"] = tel
        params["theAPPid"] = "dalianrenda0001"
        params["thecharset"] = "utf-8"
        
        self.request("resetpassword", params: params, completion: completion)
    }

}
