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
        
        self.httpReqURL = self.httpReqURL + "/appjiekout/jiekou/gonggong.asmx?op=CheckLogin"
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["loginname"] = account
        params["password"] = password
        params["phonetype"] = "iPhone"
        params["theAPPid"] = "dalianrenda0001"
        params["thecharset"] = "utf-8"
        
        self.request(params, completion: completion)
     }
    
}