//
//  PCSDataManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import CoreData
import ReachabilitySwift

class PCSDataManager: NSObject, XMLParserDelegate {
    
    static let _pcsDataManager = PCSDataManager()
    
    var photoURL: String {
        return photoDownloadURL
    }
    
    var reachability: Reachability?
    var accountManager = AccountManager()
    var content: ContentInfo = ContentInfo()
    var isLaunch: Bool = true
    var getSMSCount = 60
//    var getSMSCountTimer: NSTimer? = nil
    var getSMSBlock: ((Int) -> Void)? = nil
    var commonCompletionBlock: ((Bool, String?) -> Void)? = nil
    var appValid = true
    var appValidErrMsg: String? = nil
    var xmlElement: String = ""
    
    var deviceToken: String {
        guard let token = JPUSHService.registrationID() else {
            return "NonToken"
        }
        
        return token
    }
    
    // MARK: - Class Functions
    
    class func defaultManager() -> PCSDataManager {
        return _pcsDataManager;
    }
    
    override init() {
        super.init()
        
        reachability = Reachability.init()
        reachability?.whenUnreachable = { reach in
            DispatchQueue.main.async(execute: { () -> Void in
                let alert = UIAlertView(title: nil, message: "", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            })
        }
        
        do {
            try reachability?.startNotifier()
        }
        catch {}
    }
    
    deinit {
        reachability?.stopNotifier()
    }
    
    func countingDown(_ timer: Timer) {
        getSMSCount -= 1
        getSMSBlock?(getSMSCount)
        
        if getSMSCount == 0 {
            timer.invalidate()
//            getSMSCountTimer = nil
        }
    }
    
    func deleteLocalVariable(_ completion: @escaping () -> Void) {
        let fetchReq: NSFetchRequest<VariableEntity> = NSFetchRequest(entityName: "VariableEntity")
        let context = CoreDataManager.defalutManager().managedObjectContext
        
        do {
            let fetchObjects = try context.fetch(fetchReq)
            guard let localVariable = fetchObjects.first else {
                completion()
                
                return
            }
            
            context.delete(localVariable as! NSManagedObject)
            
            CoreDataManager.defalutManager().saveContext({
                DispatchQueue.main.async(execute: {
                    completion()
                })
            })
        }
        catch {
            completion()
        }
    }
    
    func fireCountingDownGetSMS(_ block: @escaping (Int) -> Void) {
//        if getSMSCountTimer != nil {
//            getSMSCountTimer!.invalidate()
//            getSMSCountTimer = nil
//        }
        
        getSMSCount = 60
        getSMSBlock = block

        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PCSDataManager.countingDown(_:)), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func getLocalVariable() -> Variable? {
        let fetchReq: NSFetchRequest<VariableEntity> = NSFetchRequest(entityName: "VariableEntity")
        let context = CoreDataManager.defalutManager().managedObjectContext
        
        do {
            let fetchObjects = try context.fetch(fetchReq)
            guard let localVariable = fetchObjects.first else {
                return nil
            }
            
            let variable = Variable()
            variable.token = localVariable.identifier
            variable.title = localVariable.title
            variable.type = localVariable.typeID
            variable.typeTitle = localVariable.typeTitle
            variable.content = localVariable.content
            variable.time = localVariable.time
            variable.remark = localVariable.remark
            variable.persons = localVariable.persons
            
            if localVariable.photos != nil {
                variable.photos = NSKeyedUnarchiver.unarchiveObject(with: localVariable.photos!) as! Array<String>
            }
            
            return variable
        }
        catch {
            return nil
        }
    }
    
    func saveVariableToLocal(_ variable: Variable, completion: @escaping () -> Void) {
        let fetchReq: NSFetchRequest<VariableEntity> = NSFetchRequest(entityName: "VariableEntity")
        let context = CoreDataManager.defalutManager().managedObjectContext
        
        do {
            let fetchObjects = try context.fetch(fetchReq)
            var localVariable: VariableEntity? = nil
            
            if fetchObjects.count > 0 {
                localVariable = fetchObjects.first
            }
            else {
                localVariable = NSEntityDescription.insertNewObject(forEntityName: "VariableEntity", into: context) as? VariableEntity
            }
            
            localVariable?.identifier = variable.token
            localVariable?.title = variable.title
            localVariable?.content = variable.content
            localVariable?.typeID = variable.type
            localVariable?.typeTitle = variable.typeTitle
            localVariable?.persons = variable.persons
            localVariable?.time = variable.time
            localVariable?.remark = variable.remark
            
            if variable.photos.count > 0 {
                localVariable?.photos = NSKeyedArchiver.archivedData(withRootObject: variable.photos)
            }
            
            CoreDataManager.defalutManager().saveContext({
                DispatchQueue.main.async(execute: { 
                    completion()
                })
            })
        }
        catch {
            completion()
        }
    }
    
    // MARK: - Server Interface
    
    /// @brief 添加活动
    func addActivity(_ activity: Activity, completion: SimpleCompletion?) {
        let req = AddActivityReq()
        req.activity = activity
        
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    completion?(true, nil, errorCode)
                }
                else {
                    completion?(false, "添加失败，请检查您的网络状况", errorCode)
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                guard let responseString = HttpBaseReq.parseResponse(value) else {
                    return
                }
                
                if ((responseString as! NSString).intValue >= 1) {
                    success = true
                }
                else {
                    errorCode = responseString as? String
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
    func addVariable(_ variable: Variable, completion: SimpleCompletion?) {
        let req = AddVariableReq()
        req.variable = variable
        
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    completion?(true, nil, errorCode)
                }
                else {
                    completion?(false, "添加失败，请检查您的网络状况", errorCode)
                }
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                guard let responseString = HttpBaseReq.parseResponse(value) as? String else {
                    return
                }
                
                if ((responseString as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    errorCode = responseString
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
    func appAvaliable(_ completion: ((Bool, String?) -> Void)?) {
        let url = "https://dlpiiappfiles.b0.upaiyun.com/cross.xml"
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
            guard data != nil else {
                completion?(true, nil)
                
                return
            }
            
            self.commonCompletionBlock = completion
            
            let parser = XMLParser(data: data!)
            parser.delegate = self
            parser.parse()
        }) 
        
        task.resume()
    }
    
    func getTypeInfo(_ type: PCSType, completion: ((Array<PCSTypeInfo>?, String?) -> Void)?) {
        let req = GetActivityTypesReq()
        req.type = type
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<PCSTypeInfo>? = nil
            var errorCode: String? = nil
            
            defer {
                completion?(relArray, errorCode)
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
                
                relArray = [PCSTypeInfo]()
                for i in 0..<info.count {
                    let dict = (info as! NSArray)[i] as! Dictionary<String, AnyObject>
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
    
    func getGroup(_ completion: ((Array<Group>?, String?) -> Void)?) {
        let req = GetGroupReq()
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Group>? = nil
            var errorCode: String? = nil
            
            defer {
                completion?(relArray, errorCode)
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
                
                relArray = [Group]()
                for i in 0..<info.count {
                    let dict = (info as! NSArray)[i] as! Dictionary<String, AnyObject>
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
    
    func getPersonList(_ activityID: String, completion: ((Array<Person>?, String?) -> Void)?) {
        let req = GetPersonListReq()
        req.activityID = activityID
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Person>? = nil
            var errorCode: String? = nil
            
            defer {
                completion?(relArray, errorCode)
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
                    person.identifier = dict["RDDB_ID"] as? String
                    person.congressID = dict["RDDB_GUID"] as? String
                    person.name = dict["RDDB_NAME"] as? String
                    person.organizationID = dict["RDDB_Org"] as? String
                    relArray?.append(person)
                }
            }
        }
    }
    
    func getCongressList(_ organizationID: String, completion: ((Array<Person>?, String?) -> Void)?) {
        let req = GetCongressListReq()
        req.organizationID = organizationID
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Person>? = nil
            var errorCode: String? = nil
            
            defer {
                completion?(relArray, errorCode)
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
                    person.identifier = dict["RDDB_ID"] as? String
                    person.congressID = dict["RDDB_Guid"] as? String
                    person.name = dict["RDDB_Name"] as? String
                    person.organizationID = dict["RDDB_Org"] as? String
                    relArray?.append(person)
                }
            }
        }
    }
    
    func getActivityList(_ type: String, completion: ((Array<Activity>?, String?) -> Void)?) {
        let req = GetActivitiesReq()
        req.type = type
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Activity>? = nil
            var errorCode: String? = nil
            
            defer {
                completion?(relArray, errorCode)
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
                
                relArray = [Activity]()
                for i in 0..<info.count {
                    let dict = (info as! NSArray)[i] as! Dictionary<String, AnyObject>
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
    
    func getVariableList(_ completion: ((Array<Variable>?, String?) -> Void)?) {
        let req = GetVariablesReq()
        
        req.requestCompletion { (response) -> Void in
            var relArray: Array<Variable>? = nil
            var errorCode: String? = nil
            
            defer {
                completion?(relArray, errorCode)
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
                
                relArray = [Variable]()
                for i in 0..<info.count {
                    let dict = (info as! NSArray)[i] as! Dictionary<String, AnyObject>
                    let variable = Variable()
                    
                    if dict["lvzhi_id"] is String {
                        variable.identifier = dict["lvzhi_id"] as? String
                    }
                    else {
                        variable.identifier = "\(dict["lvzhi_id"]!)"
                    }
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
                    
                    relArray?.append(variable)
                }
            }
        }
    }
    
    func htmlURL(_ page: String) -> String {
        return "\(serverURL1)\(page)UserID=\(self.accountManager.user!.identifier!)&MobileLoginId=\(self.accountManager.user!.token!)"
    }
    
    // MARK: - NSXMLParserDelegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        xmlElement = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        xmlElement += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "crosscanel" {
            appValid = xmlElement == "0"
        }
        else if elementName == "canelstring" {
            appValidErrMsg = xmlElement
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        commonCompletionBlock?(appValid, appValidErrMsg)
    }
    
}