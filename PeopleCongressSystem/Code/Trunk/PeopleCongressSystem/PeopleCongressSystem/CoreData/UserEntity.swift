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
    var photoName: String?
    var qrCode: String?
    var organization: String?
    var congressCode: String?
    var gender: String?
    var birthday: String?
    var nation: String?
    var job: String?
    var address: String?
    var zip: String?
    var party: String?
    var education: String?
    var educationWork: String?
    var workTime: String?
    var tel: String?
    var place: String?
    var state: Int? = 0 //0：往界人大代表; 1：当界人大代表
    var remark: String?
    var sort: Int? = 0
    var addTime: String?
    var addUser: String?
    var hasDeleted: Bool? = false
    var organizationID: String?

// Insert code here to add functionality to your managed object subclass

}
