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
    
}
