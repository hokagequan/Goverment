//
//  GetUnCheckInListReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/5/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetUnCheckInListReq: HttpBaseReq {

    var activityID: Int = 0
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(_ completion: ((Bool, Array<Person>?, String?) -> Void)?) {
        var params = [String: AnyObject]()
        params["huodongid"] = activityID as AnyObject?
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token as AnyObject?
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field as AnyObject?
        params["thecharset"] = "gb2312" as AnyObject?
        
        self.request("getuncomelist", nameSpace: "gongzuorenyuan", params: params) { (response) -> Void in
            var success: Bool = false
            var persons: Array<Person>? = nil
            var errorCode: String? = nil
            
            defer {
                completion?(success, persons, errorCode)
            }
            
            guard let rsp = HttpBaseReq.parseResponse(response?.result.value) else {
                return
            }
            
            if rsp is String {
                errorCode = rsp as? String
                return
            }
            
            success = true
            persons = [Person]()
            let personsInfo = rsp as! Array<Dictionary<String, String>>
            
            for info in personsInfo {
                let person = Person()
                person.identifier = info["RDDB_GUID"]
                person.congressID = info["RDDB_GUID"]
                person.name = info["RDDB_NAME"]
                person.organizationID = info["RDDB_Org"]
                person.organization = info["DBT_NAME"]
                person.mobile = info["dianhua"]
                person.huanxin = info["huanxinhao"]
                
                persons?.append(person)
            }
        }
    }

}
