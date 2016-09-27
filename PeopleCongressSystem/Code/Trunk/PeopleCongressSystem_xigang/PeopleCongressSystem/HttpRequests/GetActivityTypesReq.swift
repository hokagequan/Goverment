//
//  GetActivityTypesReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class GetActivityTypesReq: HttpBaseReq {
    
    var type: PCSType = PCSType.Congress
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["Code"] = type.rawValue as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("GetDic", nameSpace: "gonggong", params: params, completion: completion)
    }
    
}
