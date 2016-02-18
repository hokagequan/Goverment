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
        
        do {
            let fetchObjects = try context.executeFetchRequest(fetchReq)
            user = fetchObjects.first as? UserEntity
        }
        catch {
            user = nil
        }
    }
    
    func signIn(account: String, password: String, completion: ((Bool, String) -> Void)?) {
        let req = SignInReq()
        req.account = account
        req.password = password
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            if result?.isFailure == true {
                completion?(false, "连接服务器错误")
                
                return
            }
            
            guard let value = result?.value else {
                completion?(false, "连接服务器错误")
                
                return
            }
            
            let context = CoreDataManager.defalutManager().managedObjectContext
            if self.user == nil {
                self.user = NSEntityDescription.insertNewObjectForEntityForName("UserEntity", inManagedObjectContext: context) as? UserEntity
            }
            
            // TODO: 登录成功，存入相关信息
            self.user?.account = account
            self.user?.password = password
            
            CoreDataManager.defalutManager().saveContext()
        }
    }
    
}
