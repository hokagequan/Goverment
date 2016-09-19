//
//  GetUserInfoReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/5/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class GetUserInfoReq: HttpBaseReq {
    
    var key: String = ""
    var values = [String]()

    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: ((Array<Person>?) -> Void)?) {
        var params = [String: AnyObject]()
        params["SQKcel"] = key
        params["ustringlist"] = (values as NSArray).componentsJoinedByString(",")
        params["orderstring"] = ""
        params["CheckTicket"] = PCSDataManager.defaultManager().accountManager.user!.token
        params["FieldID"] = PCSDataManager.defaultManager().accountManager.user!.field
        params["thecharset"] = "gb2312"
        
        self.request("GetUserinformation2", nameSpace: "gonggong", params: params) { (response) -> Void in
            var relArray: Array<Person>? = nil
            var errorCode: String? = nil
            
            defer {
                completion?(relArray)
            }
            
            let result = response?.result
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    return
                }
                
                guard let info = HttpBaseReq.parseResponse(value) else {
                    return
                }
                
                if info is String {
                    errorCode = info as? String
                    return
                }
                
                relArray = [Person]()
                for i in 0..<info.count {
                    let dict = (info as! NSArray)[i] as! Dictionary<String, AnyObject>
                    let person = Person()
                    person.identifier = dict["UserId"] as? String
                    person.congressID = dict["UserGuid"] as? String
                    person.name = dict["UserFirstName"] as? String
                    person.huanxin = dict["huanxinID"] as? String
                    person.mobile = dict["bindphone"] as? String
                    person.photoName = dict["RDDB_HeadPic"] as? String
                    relArray?.append(person)
                }
            }
        }
    }
    
}
