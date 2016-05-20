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
    
    func requestSimpleCompletion(completion: ((Bool) -> Void)?) {
        let requestURL = NSURLRequest(URL: NSURL(string: serverURL1 + "appjiekout/jiekou/npc-android-version.xml")!)
        let request = Alamofire.request(requestURL)
        request.responseString(completionHandler: { (response) in
            guard let value = response.result.value else {
                completion?(false)
                
                return
            }
            
            guard let range = value.rangeOfString("<needca>") else {
                completion?(false)
                
                return
            }
            
            let relValue = value.substringWithRange(Range(range.endIndex..<range.endIndex.advancedBy(1)))
            
            completion?(relValue == "1")
        })
    }
    
}
