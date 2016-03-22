//
//  GetVariableDetailReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/22.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetVariableDetailReq: HttpBaseReq {

    var variable: Variable?
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: ((Bool) -> Void)?) {
        var params = [String: AnyObject]()
        params["lvZhiId"] = variable?.token
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("GetLvZhiDetails", nameSpace: "rendadaibiao", params: params) { (response) -> Void in
            let result = response?.result
            var success = false
            
            defer {
                completion?(success)
            }
            
            if result?.isSuccess == true {
                guard let info = HttpBaseReq.parseResponse(result?.value) else {
                    return
                }
                
                success = true
                let variableInfo = (info as! Array<Dictionary<String, AnyObject>>).first
                self.variable?.type = variableInfo?["lvzhi_type"] as? String
                self.variable?.content = variableInfo?["lvzhi_content"] as? String
                self.variable?.persons = variableInfo?["lvzhi_cyr"] as? String
                self.variable?.typeTitle = variableInfo?["name"] as? String
                let photos = variableInfo?["urls"] as? String
                
                if photos != nil {
                    self.variable?.photos = (photos?.componentsSeparatedByString(","))!
                }
            }
        }
    }
    
}
