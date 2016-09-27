//
//  GetAppInfoReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/5/20.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import Alamofire

class GetAppInfoReq: HttpBaseReq {
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(_ completion: ((Bool) -> Void)?) {
        let requestURL = URLRequest(url: URL(string: serverURL1 + "appjiekout/jiekou/npc-android-version.xml")!)
        let request = Alamofire.request(requestURL)
        request.responseString(completionHandler: { (response) in
            guard let value = response.result.value else {
                completion?(false)
                
                return
            }
            
            guard let range = value.range(of: "<needca>") else {
                completion?(false)
                
                return
            }
            
            let lo = value.index(range.upperBound, offsetBy: 0)
            let hi = value.index(after: range.upperBound)
            let subRange = lo..<hi
            let relValue = value.substring(with: subRange)
            
            completion?(relValue == "1")
        })
    }
    
}
