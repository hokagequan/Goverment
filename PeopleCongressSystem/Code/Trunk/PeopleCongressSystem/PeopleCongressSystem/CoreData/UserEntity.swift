//
//  UserEntity.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/24.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import CoreData


class UserEntity: NSManagedObject {
    
    var identifier: String?
    var congressID: String?
    var name: String?
    var token: String?
    var memberType: String?
    var field: String?

// Insert code here to add functionality to your managed object subclass

}
