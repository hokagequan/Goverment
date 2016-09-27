//
//  GetVariablesReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/10.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetVariablesReq: HttpBaseReq {
    
    var type: String = ""
    var from: Int = 1
    var to: Int = 1000
    // 可空，用于查询
    var name: String? = nil
    var hasSubmitted: Bool = false
    var hasChecked: Bool = false
    
    override init() {
        super.init()
    }
    
    override func requestCompletion(_ completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["pageIndex"] = from as AnyObject?
        params["pageSize"] = to as AnyObject?
        params["Name"] = "" as AnyObject?
        params["IsPost"] = "" as AnyObject?
        params["ZT"] = "" as AnyObject?
        params["UserGuid"] = PCSDataManager.defaultManager().accountManager.user!.congressID as AnyObject?
        params["Type"] = type as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("GetLvZhiList", nameSpace: "rendadaibiao", params: params, completion: completion)
    }

}
