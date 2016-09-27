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
    
    func requestSimpleCompletion(_ completion: ((Bool, String?) -> Void)?) {
        var params = [String: AnyObject]()
        params["huodongId"] = activity?.identifier as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("GetHuoDonginfo", nameSpace: "gongzuorenyuan", params: params) { (response) -> Void in
            let result = response?.result
            var success = false
            var errorCode: String? = nil
            
            defer {
                completion?(success, errorCode)
            }
            
            if result?.isSuccess == true {
                guard let info = HttpBaseReq.parseResponse(result?.value) else {
                    return
                }
                
                if info is String {
                    errorCode = info as? String
                    return
                }
                
                success = true
                let activityInfo = (info as! Array<Dictionary<String, AnyObject>>).first
                self.activity?.endTime = activityInfo?["huodong_shijian_js"] as? String
                self.activity?.content = activityInfo?["huodong_shuoming"] as? String
                self.activity?.totalPersonCount = activityInfo?["yingdao"] as! Int
                self.activity?.checkedInPersonCount = activityInfo?["shidao"] as! Int
            }
        }
    }
    
}
