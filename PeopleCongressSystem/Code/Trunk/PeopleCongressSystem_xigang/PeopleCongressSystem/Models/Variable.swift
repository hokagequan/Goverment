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
    var typeTitle: String? = nil
    var location: String? = nil
    var content: String? = nil
    var remark: String? = nil
    var time: String? = nil
    var checkTime: String? = nil
    var createTime: String? = nil
    var createPerson: String? = nil
    var checked: Bool = false
    var submitted: Bool = false
    var persons: String? = nil
    var photos = [String]()
    
    // MARK: - NSCopying
    
    func copy(with zone: NSZone?) -> Any {
        let variable = Variable()
        variable.identifier = self.identifier
        variable.token = self.token
        variable.title = self.title
        variable.typeTitle = self.typeTitle
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
        variable.photos = self.photos
        
        return variable
    }
    
}
