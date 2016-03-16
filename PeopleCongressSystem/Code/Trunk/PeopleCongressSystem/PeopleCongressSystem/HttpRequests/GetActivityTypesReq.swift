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
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["Code"] = type.rawValue
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("GetDic", nameSpace: "gonggong", params: params, completion: completion)
    }
    
}