//
//  AccountManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import CoreData

class AccountManager {
    
    var user: UserEntity? = nil
    
    init() {
        self.getDefaultUser()
    }
    
    func getDefaultUser() {
        let context = CoreDataManager.defalutManager().managedObjectContext
        let fetchReq = NSFetchRequest(entityName: "UserEntity")
        fetchReq.predicate = NSPredicate(format: "isDefault == %@", true)
        
        do {
            let fetchObjects = try context.executeFetchRequest(fetchReq)
            user = fetchObjects.first as? UserEntity
        }
        catch {
            user = nil
        }
    }
    
    func signIn(account: String, password: String, completion: ((Bool, String?) -> Void)?) {
        let req = SignInReq()
        req.account = account
        req.password = password
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            if result?.isFailure == true {
                completion?(false, "连接服务器错误")
                
                return
            }
            
            guard let _ = result?.value else {
                completion?(false, "连接服务器错误")
                
                return
            }
            
            let context = CoreDataManager.defalutManager().managedObjectContext
            let fetchReq = NSFetchRequest(entityName: "UserEntity")
            
            do {
                self.user = nil
                let users = try context.executeFetchRequest(fetchReq) as! Array<UserEntity>
                
                for storeUser in users {
                    storeUser.isDefault = false
                    
                    if storeUser.account == req.account {
                        self.user = storeUser
                    }
                }
                
                if self.user == nil {
                    self.user = NSEntityDescription.insertNewObjectForEntityForName("UserEntity", inManagedObjectContext: context) as? UserEntity
                }
                
                self.user?.account = account
                self.user?.password = password
                self.user?.isDefault = true
                
                CoreDataManager.defalutManager().saveContext(nil)
                
                // TODO: 设置登录人员类型
                PCSDataManager.defaultManager().content = WorderContentInfo()
                completion?(true, nil)
            }
            catch {
                completion?(false, "数据库错误")
            }
        }
    }
    
}
