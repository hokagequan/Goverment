//
//  Activity.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class Activity: NSObject {
    
    var identifier: String? = nil
    var title: String? = nil
    var type: String? = nil
    var location: String? = nil
    var content: String? = nil
    var beginTime: String? = nil
    var endTime: String? = nil
    var organization: String? = nil
    var createTime: String? = nil
    var manager: String? = nil
    var available: Bool = false
    var finished: Bool = false
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
    
}