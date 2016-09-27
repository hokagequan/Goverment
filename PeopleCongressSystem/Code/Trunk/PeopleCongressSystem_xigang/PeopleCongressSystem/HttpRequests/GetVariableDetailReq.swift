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
    
    func requestSimpleCompletion(_ completion: ((Bool, String?) -> Void)?) {
        var params = [String: AnyObject]()
        params["lvZhiId"] = variable?.token as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("GetLvZhiDetails", nameSpace: "rendadaibiao", params: params) { (response) -> Void in
            let result = response?.result
            var success = false
            var errorCode: String? = nil
            
            defer {
                completion?(success, errorCode)
            }
            
            if result?.isSuccess == true {
                guard let info = HttpBaseReq.parseResponse(result?.value) else {
                    return
                }
                
                if info is String {
                    errorCode = info as? String
                    return
                }
                
                success = true
                let variableInfo = (info as! Array<Dictionary<String, AnyObject>>).first
                self.variable?.type = variableInfo?["lvzhi_type"] as? String
                self.variable?.content = variableInfo?["lvzhi_content"] as? String
                self.variable?.persons = variableInfo?["lvzhi_cyr"] as? String
                self.variable?.typeTitle = variableInfo?["name"] as? String
                let photos = variableInfo?["urls"] as? String
                
                if photos != nil && photos != "" {
                    self.variable?.photos = (photos?.components(separatedBy: ","))!
                }
            }
        }
    }
    
}
