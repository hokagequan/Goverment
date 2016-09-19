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
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["UserGuid"] = PCSDataManager.defaultManager().accountManager.user!.congressID
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("GetRDDBinfoByUserGuid", nameSpace: "gongzuorenyuan", params: params, completion: completion)
    }
    
}
