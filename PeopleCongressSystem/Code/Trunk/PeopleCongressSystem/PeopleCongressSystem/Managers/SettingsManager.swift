//
//  SettingsManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

enum SettingKey: String {
    case RememberPassword = "kRememberPassword"
    case AutoSignIn = "kAutoSignIn"
    case GesturePassword = "kGesturePassword"
    case Server = "kServer"
}

class SettingsManager {
    
    // MARK: - Class Function
    
    class func getData(key: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    class func saveData(object: AnyObject, key: String) {
        NSUserDefaults.standardUserDefaults().setObject(object, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
}
