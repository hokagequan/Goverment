//
//  VariableEntity+CoreDataProperties.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/5.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension VariableEntity {

    @NSManaged var title: String?
    @NSManaged var typeID: String?
    @NSManaged var typeTitle: String?
    @NSManaged var content: String?
    @NSManaged var remark: String?
    @NSManaged var time: String?
    @NSManaged var persons: String?
    @NSManaged var photos: Data?
    @NSManaged var identifier: String?

}
