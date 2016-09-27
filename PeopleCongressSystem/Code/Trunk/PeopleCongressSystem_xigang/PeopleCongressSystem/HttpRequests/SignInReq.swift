//
//  SignInReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/18.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class SignInReq: HttpBaseReq {
    
    var account: String? = nil
    var password: String? = nil
    
    override init() {
        super.init()
        
//        self.httpReqURL = self.httpReqURL + "/appjiekout/jiekou/gonggong.asmx?op=CheckLogin"
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["loginname"] = account as AnyObject?
        params["password"] = password as AnyObject?
        params["phonetype"] = "iPhone;\(GlobalUtil.phoneModel())" as AnyObject?
        params["theAPPid"] = "dalianrenda0001" as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
//        self.request(params, completion: completion)
        self.request("CheckLogin", nameSpace: "gonggong", params: params, completion: completion)
     }
    
}
