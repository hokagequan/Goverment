//
//  GetActivityDetaildReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetActivityDetaildReq: HttpBaseReq {

    var activity: Activity?
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: ((Bool) -> Void)?) {
        var params = [String: AnyObject]()
        params["huodongId"] = activity?.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("GetHuoDonginfo", nameSpace: "gongzuorenyuan", params: params) { (response) -> Void in
            let result = response?.result
            var success = false
            
            defer {
                completion?(success)
            }
            
            if result?.isSuccess == true {
                guard let info = HttpBaseReq.parseResponse(result?.value) else {
                    return
                }
                
                success = true
                let activityInfo = (info as! Array<Dictionary<String, AnyObject>>).first
                self.activity?.endTime = activityInfo?["huodong_shijian_js"] as? String
                self.activity?.content = activityInfo?["huodong_shuoming"] as? String
            }
        }
    }
    
}
