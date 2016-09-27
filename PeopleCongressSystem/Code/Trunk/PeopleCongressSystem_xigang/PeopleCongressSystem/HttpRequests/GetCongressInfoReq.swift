//
//  GetCongressInfoReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/16.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetCongressInfoReq: HttpBaseReq {

    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["UserGuid"] = PCSDataManager.defaultManager().accountManager.user!.congressID as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("GetRDDBinfoByUserGuid", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}
