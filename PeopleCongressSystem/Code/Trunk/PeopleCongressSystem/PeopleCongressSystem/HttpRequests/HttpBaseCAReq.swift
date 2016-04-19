//
//  HttpBaseCAReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/18.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import Alamofire

class HttpBaseCAReq {
    let serverCA = "http://218.25.86.214:2010/ssoworker"
    
    func request(method: String, params: Dictionary<String, String>?, completion: HttpReqJSONCompletion) {
        var expandParams = "cmd=\(method)"
        if params != nil {
            for key in params!.keys {
                expandParams += "&\(key)=\(params![key]!)"
            }
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: serverCA)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = expandParams.dataUsingEncoding(NSUTF8StringEncoding)
        Alamofire.request(request)
                .responseJSON(completionHandler: completion)
    }
    
}
