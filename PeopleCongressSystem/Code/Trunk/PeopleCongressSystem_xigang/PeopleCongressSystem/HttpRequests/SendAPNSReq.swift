//
//  SendAPNSReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/5/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

enum SendType: String {
    case SMS = "duanxin"
    case APNS = "tuisong"
}

class SendAPNSReq: HttpBaseReq {

    var mobile: String? = ""
    var congressID = ""
    var type = SendType.APNS
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(_ completion: @escaping (Bool, String?) -> Void) {
        var params = [String: String]()
        params["rddb_guid"] = congressID
        params["rddb_phone"] = mobile
        params["alerttype"] = type.rawValue
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["thecharset"] = "gb2312"
        
        self.request("sendalert", nameSpace: "gongzuorenyuan", params: params) { (response) in
            var success = false
            var errorCode: String? = nil
            
            defer {
                completion(success, errorCode)
            }
            
            guard let repValue = HttpBaseReq.parseResponse(response?.result.value) as? String else {
                return
            }
            
            if Int(repValue)! > 0 {
                success = true
                
                return
            }
            
            errorCode = repValue
        }
    }
    
}
