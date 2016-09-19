//
//  UserEntity+CoreDataProperties.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/24.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserEntity {

    @NSManaged var account: String?
    @NSManaged var gesturePassword: String?
    @NSManaged var password: String?
    @NSManaged var isDefault: NSNumber?

}
