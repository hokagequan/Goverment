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
        params["thecharset"] = "utf-8"
        
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
        params["thecharset"] = "utf-8"
        
        self.request("HuoDongMod", nameSpace: "gongzuorenyuan", params: params) { (response) -> Void in
            let result = response?.result
            
            var success: Bool = false
            
            defer {
                if success == true {
                    completion?(true, "修改成功")
                }
                else {
                    completion?(false, "修改失败")
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                if ((value as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
}
