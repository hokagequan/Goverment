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
    
    func requestSimpleCompletion(completion: (String) -> Void) {
        var params = [String: AnyObject]()
        params["phoneID"] = tel
        params["newpwd"] = password
        params["theAPPid"] = "dalianrenda0001"
        params["thecharset"] = "gb2312"
        
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
