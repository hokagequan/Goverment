//
//  AddActivityReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class AddActivityReq: HttpBaseReq {
    
    var activity: Activity = Activity()
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
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
        
        self.request("HuoDongAdd", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}
