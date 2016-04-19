//
//  SignCAReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class SignCAReq: HttpBaseCAReq {
    
    var rand = ""
    var cert = ""
    var signed = ""

    func requestSimple(completion: (Bool) -> Void) {
        var params = [String: String]()
        params["rand"] = rand
        params["cert"] = cert
        params["signed"] = signed
        
        self.request("certlogin", params: params) { (response) in
            guard let value = response?.result.value else {
                completion(false)
                
                return
            }
            
            let success = value["ret"] as? Bool
            completion(success ?? false)
        }
    }
    
}
