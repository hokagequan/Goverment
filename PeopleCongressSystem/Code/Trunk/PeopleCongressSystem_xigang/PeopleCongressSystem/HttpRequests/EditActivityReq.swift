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
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["huodong_id"] = activity.identifier as AnyObject?
        params["huodongName"] = activity.title as AnyObject?
        params["hdlx"] = activity.type as AnyObject?
        params["hddd"] = activity.location as AnyObject?
        params["hdsj"] = activity.beginTime as AnyObject?
        params["hdsjover"] = activity.endTime as AnyObject?
        params["hdsm"] = activity.content as AnyObject?
        params["zzdw"] = activity.organization as AnyObject?
        params["user_list"] = activity.serilizePersons() as AnyObject?
        params["UserId"] = PCSDataManager.defaultManager().accountManager.user!.identifier as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("HuoDongMod", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
    func requestSimpleCompletion(_ completion: SimpleCompletion?) {
        var params = [String: AnyObject]()
        params["huodong_id"] = activity.identifier as AnyObject?
        params["huodongName"] = activity.title as AnyObject?
        params["hdlx"] = activity.type as AnyObject?
        params["hddd"] = activity.location as AnyObject?
        params["hdsj"] = activity.beginTime as AnyObject?
        params["hdsjover"] = activity.endTime as AnyObject?
        params["hdsm"] = activity.content as AnyObject?
        params["zzdw"] = activity.organization as AnyObject?
        params["user_list"] = activity.serilizePersons() as AnyObject?
        params["UserId"] = PCSDataManager.defaultManager().accountManager.user!.identifier as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
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
