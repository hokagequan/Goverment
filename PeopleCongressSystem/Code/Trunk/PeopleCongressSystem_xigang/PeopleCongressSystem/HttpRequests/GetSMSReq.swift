//
//  GetSMSReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/18.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetSMSReq: HttpBaseReq {
    
    var mobile = ""

    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: (String) -> Void) {
        var params = [String: String]()
        params["phoneID"] = mobile
        params["theAPPid"] = "dalianrenda0001"
        params["thecharset"] = "gb2312"
        
        self.request("pwdsend", nameSpace: "gonggong", params: params) { (response) in
            var message = "网络异常，请稍后再试"
            
            defer {
                completion(message)
            }
            
            guard let value = response?.result.value else {
                return
            }
            
            guard let repValue = HttpBaseReq.parseResponse(value) as? String else {
                return
            }
            
            message = repValue
        }
    }
    
}
