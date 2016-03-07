//
//  PCSDataManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class PCSDataManager {
    
    static let _pcsDataManager = PCSDataManager()
    
    var accountManager = AccountManager()
    var content: ContentInfo = ContentInfo()
    
    // MARK: - Class Functions
    
    class func defaultManager() -> PCSDataManager {
        return _pcsDataManager;
    }
    
    init() {
    }
    
    /// @brief 添加活动
    func addActivity(activity: Activity, completion: SimpleCompletion?) {
        let req = AddActivityReq()
        req.activity = activity
        
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            
            defer {
                if success == true {
                    completion?(true, nil)
                }
                else {
                    completion?(false, "添加失败")
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                if ((value as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
    func getTypeInfo(type: PCSType, completion: ((Array<PCSTypeInfo>?) -> Void)?) {
        let req = GetActivityTypesReq()
        req.type = type
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<PCSTypeInfo>? = nil
            
            defer {
                completion?(relArray)
            }
            
            let result = response?.result
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    return
                }
                
                guard let info = HttpBaseReq.parseResponse(value) as? NSArray else {
                    return
                }
                
                relArray = [PCSTypeInfo]()
                for i in 0..<info.count {
                    let dict = info[i] as! Dictionary<String, AnyObject>
                    let typeInfo = PCSTypeInfo()
                    typeInfo.title = dict["Name"] as? String
                    typeInfo.code = dict["GUID"] as? String
                    typeInfo.sort = dict["shuzi"] as? String
                    typeInfo.type = dict["DmlbID"] as? String
                    relArray?.append(typeInfo)
                }
            }
        }
    }
    
    func getGroup(completion: ((Array<Group>?) -> Void)?) {
        let req = GetGroupReq()
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Group>? = nil
            
            defer {
                completion?(relArray)
            }
            
            let result = response?.result
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    return
                }
                
                guard let info = HttpBaseReq.parseResponse(value) as? NSArray else {
                    return
                }
                
                relArray = [Group]()
                for i in 0..<info.count {
                    let dict = info[i] as! Dictionary<String, AnyObject>
                    let group = Group()
                    group.identifier = dict["GUID"] as? String
                    group.number = dict["DisBH"] as? String
                    group.title = dict["DisName"] as? String
                    group.parentID = dict["ParentID"] as? String
                    group.sort = dict["Orderid"] as? String
                    group.personCount = dict["Dbsl"] as? String
                    relArray?.append(group)
                }
            }
        }
    }
    
    func getPersonList(activityID: String, completion: ((Array<Person>?) -> Void)?) {
        let req = GetPersonListReq()
        req.activityID = activityID
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Person>? = nil
            
            defer {
                completion?(relArray)
            }
            
            let result = response?.result
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    return
                }
                
                guard let info = HttpBaseReq.parseResponse(value) as? NSArray else {
                    return
                }
                
                relArray = [Person]()
                for i in 0..<info.count {
                    let dict = info[i] as! Dictionary<String, AnyObject>
                    let person = Person()
                    person.identifier = dict["RDDB_ID"] as? String
                    person.congressID = dict["RDDB_GUID"] as? String
                    person.name = dict["RDDB_NAME"] as? String
                    person.organizationID = dict["RDDB_NAME"] as? String
                    relArray?.append(person)
                }
            }
        }
    }
    
    func getCongressList(organizationID: String, completion: ((Array<Person>?) -> Void)?) {
        let req = GetCongressListReq()
        req.organizationID = organizationID
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Person>? = nil
            
            defer {
                completion?(relArray)
            }
            
            let result = response?.result
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    return
                }
                
                guard let info = HttpBaseReq.parseResponse(value) as? NSArray else {
                    return
                }
                
                relArray = [Person]()
                for i in 0..<info.count {
                    let dict = info[i] as! Dictionary<String, AnyObject>
                    let person = Person()
                    person.identifier = dict["RDDB_ID"] as? String
                    person.congressID = dict["RDDB_GUID"] as? String
                    person.name = dict["RDDB_NAME"] as? String
                    person.organizationID = dict["RDDB_NAME"] as? String
                    relArray?.append(person)
                }
            }
        }
    }
    
    func getActivityList(type: String, completion: ((Array<Activity>?) -> Void)?) {
        let req = GetActivitiesReq()
        req.type = type
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Activity>? = nil
            
            defer {
                completion?(relArray)
            }
            
            let result = response?.result
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    return
                }
                
                guard let info = HttpBaseReq.parseResponse(value) as? NSArray else {
                    return
                }
                
                relArray = [Activity]()
                for i in 0..<info.count {
                    let dict = info[i] as! Dictionary<String, AnyObject>
                    let activity = Activity()
                    activity.identifier = dict["huodong_ID"] as? String
                    activity.title = dict["huodong_name"] as? String
                    activity.type = dict["huodong_leixing"] as? String
                    activity.location = dict["huodong_didian"] as? String
                    activity.beginTime = dict["huodong_shijian_ks"] as? String
                    activity.endTime = dict["huodong_shijian_js"] as? String
                    activity.organization = dict["huodong_zzdw"] as? String
                    activity.available = dict["huidong_IsDel"] as! Bool
                    activity.createTime = dict["huodong_createtime"] as? String
                    activity.manager = dict["huodong_sbdw"] as? String
                    activity.finished = dict["huodong_zt"] as! Bool
                    relArray?.append(activity)
                }
            }
        }
    }
    
}
