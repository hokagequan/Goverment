//
//  GetActivityPersonsReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetActivityPersonsReq: HttpBaseReq {

    var activity: Activity? = nil
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: ((Dictionary<String, String>, String?) -> Void)?) {
        var params = [String: AnyObject]()
        params["huodongId"] = activity?.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("GethuodongUsersum", nameSpace: "gongzuorenyuan", params: params) { (response) -> Void in
            var relArray = [String: String]()
            var errorCode: String? = nil
            
            defer {
                completion?(relArray, errorCode)
            }
            
            guard let info = HttpBaseReq.parseResponse(response?.result.value) else {
                return
            }
            
            if info is String {
                errorCode = info as? String
                
                return
            }
            
            let convInfo = info as! Array<Dictionary<String, AnyObject>>
            for personInfo in convInfo {
                relArray[personInfo["RDDB_Org"] as! String] = personInfo["XQM"] as? String
            }
        }
    }
    
}
