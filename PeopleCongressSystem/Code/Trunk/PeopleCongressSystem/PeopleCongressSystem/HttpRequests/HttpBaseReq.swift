//
//  HttpBaseReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import Alamofire

typealias HttpReqCompletion = (response: Response<AnyObject, NSError>?) -> Void

class HttpBaseReq {
    
    var httpReqURL = SettingsManager.getData(SettingKey.Server.rawValue) as! String
    
    func request(params: Dictionary<String, AnyObject>, completion: HttpReqCompletion?) {
        Alamofire.request(.POST, httpReqURL, parameters: params, encoding: .JSON, headers: nil)
                 .responseJSON { (rsp) -> Void in
                    print("\(rsp)")
                    completion?(response: rsp)
                 }
    }
    
    func requestCompletion(completion: HttpReqCompletion?) {}
    
}
