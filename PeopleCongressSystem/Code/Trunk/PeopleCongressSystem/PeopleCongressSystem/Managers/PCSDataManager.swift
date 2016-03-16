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
    var isLaunch: Bool = true
    
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
    
    func addVariable(variable: Variable, completion: SimpleCompletion?) {
        let req = AddVariableReq()
        req.variable = variable
        
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
                    group.number = dict["disBH"] as? String
                    group.title = dict["disName"] as? String
                    group.parentID = dict["ParentID"] as? String
                    group.sort = dict["orderid"] as? String
                    group.personCount = dict["dbsl"] as! Int
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
                    person.congressID = dict["RDDB_Guid"] as? String
                    person.name = dict["RDDB_Name"] as? String
                    person.organizationID = dict["RDDB_Org"] as? String
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
                    activity.identifier = dict["huodong_ID"] as! Int
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
                    activity.typeTitle = dict["hdlxm"] as? String
                    relArray?.append(activity)
                }
            }
        }
    }
    
    func getVariableList(completion: ((Array<Variable>?) -> Void)?) {
        let req = GetVariablesReq()
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Variable>? = nil
            
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
                
                relArray = [Variable]()
                for i in 0..<info.count {
                    let dict = info[i] as! Dictionary<String, AnyObject>
                    let variable = Variable()
                    variable.identifier = dict["lvzhi_id"] as? String
                    variable.title = dict["lvzhi_title"] as? String
                    variable.type = dict["lvzhi_type"] as? String
                    variable.content = dict["lvzhi_content"] as? String
                    variable.remark = dict["lvzhi_remark"] as? String
                    variable.time = dict["lvzhiTime"] as? String
                    variable.createTime = dict["lvzhi_addTime"] as? String
                    variable.createPerson = dict["lvzhi_addUser"] as? String
                    variable.checked = dict["lvzhi_zt"] as! Bool
                    variable.checkTime = dict["lvzhi_AuditTime"] as? String
                    variable.token = dict["lvzhi_guid"] as? String
                    variable.submitted = dict["lvzhi_IsPost"] as! Bool
                    
                    // TODO: 参与人未处理
//                    let persons = dict["lvzhi_cyr"] as? String
                    relArray?.append(variable)
                }
            }
        }
    }
    
    func htmlURL(page: String) -> String {
        return "\(serverURL1)\(page)UserID=\(self.accountManager.user!.identifier!)&MobileLoginId=\(self.accountManager.user!.token!)"
    }
    
}
