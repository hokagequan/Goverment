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
    case Launched = "kLaunched"
    
    func value() -> AnyObject? {
        return SettingsManager.getData(self.rawValue)
    }
    
    func setValue(value: AnyObject) {
        SettingsManager.saveData(value, key: self.rawValue)
    }
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
