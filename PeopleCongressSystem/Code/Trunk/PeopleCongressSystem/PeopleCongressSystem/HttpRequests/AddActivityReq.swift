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
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
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
        
        self.request("HuoDongAdd", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}