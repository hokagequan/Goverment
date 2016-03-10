//
//  Variable.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/10.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class Variable: NSObject, NSCopying {

    var identifier: String? = nil
    var token: String? = nil
    var title: String? = nil
    var type: String? = nil
    var location: String? = nil
    var content: String? = nil
    var remark: String? = nil
    var time: String? = nil
    var checkTime: String? = nil
    var createTime: String? = nil
    var createPerson: String? = nil
    var checked: Bool = false
    var submitted: Bool = false
    var persons: Array<Person>? = nil
    
    func serilizePersons() -> String? {
        if persons == nil {
            return nil
        }
        
        var personsIDs = [String]()
        
        for person in persons! {
            if person.congressID == nil {
                continue
            }
            personsIDs.append(person.congressID!)
        }
        
        return personsIDs.joinWithSeparator(",")
    }
    
    // MARK: - NSCopying
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let variable = Variable()
        variable.identifier = self.identifier
        variable.token = self.token
        variable.title = self.title
        variable.type = self.type
        variable.location = self.location
        variable.content = self.content
        variable.remark = self.remark
        variable.time = self.time
        variable.checkTime = self.checkTime
        variable.createTime = self.createTime
        variable.createPerson = self.createPerson
        variable.checked = self.checked
        variable.submitted = self.submitted
        variable.persons = self.persons
        
        return variable
    }
    
}
