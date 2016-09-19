//
//  GetCARandReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/18.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetCARandReq: HttpBaseCAReq {

    func requestSimple(completion: (String?) -> Void) {
        self.request("getrand", params: nil) { (response) in
            guard let info = response?.result.value as? Dictionary<String, AnyObject> else {
                completion(nil)
                return
            }
            
            completion(info["rand"] as? String)
        }
    }
    
}
