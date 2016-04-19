//
//  VerifySMSReq.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/18.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import CoreData

class VerifySMSReq: HttpBaseReq {
    
    var mobile = ""
    var smsCode = ""
    
    override init() {
        super.init()
    }
    
    func requestSimpleCompletion(completion: (UserEntity?) -> Void) {
        var params = [String: String]()
        params["phoneID"] = mobile
        params["checkcode"] = smsCode
        params["theAPPid"] = "dalianrenda0001"
        params["thecharset"] = "gb2312"
        
        self.request("pwdrefer", nameSpace: "gonggong", params: params) { (response) in
            var userEntity: UserEntity? = nil
            defer {
                completion(userEntity)
            }
            
            guard let value = response?.result.value else {
                return
            }
            
            guard let rep = HttpBaseReq.parseResponse(value) as? Array<Dictionary<String, AnyObject>> else {
                return
            }
            
            guard let repValue = rep.first else {
                return
            }
            
            let account = repValue["UserName"] as? String
            let context = CoreDataManager.defalutManager().managedObjectContext
            let fetchReq = NSFetchRequest(entityName: "UserEntity")
            
            do {
                let users = try context.executeFetchRequest(fetchReq) as! Array<UserEntity>
                
                for storeUser in users {
                    if storeUser.account == account {
                        userEntity = storeUser
                    }
                }
                
                if userEntity == nil {
                    userEntity = NSEntityDescription.insertNewObjectForEntityForName("UserEntity", inManagedObjectContext: context) as? UserEntity
                }
                
                userEntity?.account = account
                userEntity?.isDefault = false
                
                userEntity?.identifier = repValue["UserId"] as? String
                userEntity?.congressID = repValue["UserGuid"] as? String
                userEntity?.name = repValue["UserFirstName"] as? String
                userEntity?.token = repValue["CheckTicket"] as? String
                userEntity?.field = repValue["FieldID"] as? String
                userEntity?.tel = self.mobile
                
                CoreDataManager.defalutManager().saveContext(nil)
            }
            catch {
            }
        }
    }

}
