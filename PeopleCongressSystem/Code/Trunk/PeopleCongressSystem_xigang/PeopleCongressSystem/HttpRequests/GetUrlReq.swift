//
//  GetUrlReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/27.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetUrlReq: HttpBaseReq {
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: SimpleCompletion?) {
        var params = [String: AnyObject]()
        params["UserId"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("getbackurl", nameSpace: "gonggong", params: params) { (response) -> Void in
            let result = response?.result
            
            var success: Bool = false
            var url: String? = nil
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    completion?(true, url, errorCode)
                }
                else {
                    completion?(false, nil, errorCode)
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                success = true
                
                guard let countRsp = HttpBaseReq.parseResponse(value) as? String else {
                    return
                }
                
                url = "\(countRsp)"
                guard let headerRange = url?.rangeOfString("?") else {
                    url = nil
                    errorCode = countRsp
                    
                    return
                }
                
                let header = url?.substringToIndex(headerRange.startIndex)
                
                switch header! {
                case "indexofRDDB", "zqzzofRDDB", "indexofGZRY", "zqzzofGZRY":
                    url = nil
                    break
                default:
                    url = "\(serverURL1)apph5/iphone/\(url!)"
                    break
                }
            }
            else {
                success = false
            }
        }
    }

}
