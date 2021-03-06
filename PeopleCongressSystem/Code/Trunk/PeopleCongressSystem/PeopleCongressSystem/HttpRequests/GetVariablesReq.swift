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
    
    override func requestCompletion(completion: HttpReqCompletion?) {
        var params = [String: AnyObject]()
        params["pageIndex"] = from
        params["pageSize"] = to
        params["Name"] = ""
        params["IsPost"] = ""
        params["ZT"] = ""
        params["UserGuid"] = PCSDataManager.defaultManager().accountManager.user!.congressID
        params["Type"] = type
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("GetLvZhiList", nameSpace: "rendadaibiao", params: params, completion: completion)
    }

}
