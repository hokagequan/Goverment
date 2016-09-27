//
//  ResetPasswordReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class ResetPasswordReq: HttpBaseReq {
    
    var password: String? = nil
    var tel: String? = nil
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(_ completion: @escaping (String) -> Void) {
        var params = [String: AnyObject]()
        params["phoneID"] = tel as AnyObject?
        params["newpwd"] = password as AnyObject?
        params["theAPPid"] = "dalianrenda0001" as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("pwdreset", nameSpace: "gonggong", params: params) { (response) in
            var message = "修改失败"
            
            defer {
                completion(message)
            }

            guard let value = HttpBaseReq.parseResponse(response?.result.value) as? String else {
                return
            }
            
            message = value
        }
    }

}
