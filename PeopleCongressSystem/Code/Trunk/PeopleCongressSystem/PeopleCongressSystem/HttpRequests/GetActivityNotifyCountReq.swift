//
//  GetActivityNotifyCountReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/25.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetActivityNotifyCountReq: HttpBaseReq {

    var photoID: String? = nil
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: SimpleCompletion?) {
        var params = [String: AnyObject]()
        params["rddb_guid"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("get_HDTXSL", nameSpace: "rendadaibiao", params: params) { (response) -> Void in
            let result = response?.result
            
            var success: Bool = false
            var count: String = "0"
            
            defer {
                if success == true {
                    completion?(true, count)
                }
                else {
                    completion?(false, "")
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                let countRsp = HttpBaseReq.parseResponse(value)
                success = true
                count = "\(countRsp!)"
            }
            else {
                success = false
            }
        }
    }
    
}
