//
//  EditActivityReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/11.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class EditActivityReq: HttpBaseReq {

    var activity: Activity = Activity()
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["huodong_id"] = activity.identifier
        params["huodongName"] = activity.title
        params["hdlx"] = activity.type
        params["hddd"] = activity.location
        params["hdsj"] = activity.beginTime
        params["hdsjover"] = activity.endTime
        params["hdsm"] = activity.content
        params["zzdw"] = activity.organization
        params["user_list"] = activity.serilizePersons()
        params["UserId"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("HuoDongMod", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
    func requestSimpleCompletion(completion: SimpleCompletion?) {
        var params = [String: AnyObject]()
        params["huodong_id"] = activity.identifier
        params["huodongName"] = activity.title
        params["hdlx"] = activity.type
        params["hddd"] = activity.location
        params["hdsj"] = activity.beginTime
        params["hdsjover"] = activity.endTime
        params["hdsm"] = activity.content
        params["zzdw"] = activity.organization
        params["user_list"] = activity.serilizePersons()
        params["UserId"] = PCSDataManager.defaultManager().accountManager.user!.identifier
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("HuoDongMod", nameSpace: "gongzuorenyuan", params: params) { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    completion?(true, "修改成功", errorCode)
                }
                else {
                    completion?(false, "修改失败，请检查您的网络状况", errorCode)
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                guard let responseString = HttpBaseReq.parseResponse(value) as? String else {
                    return
                }
                
                if ((responseString as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    errorCode = responseString
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
}
