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
    
    func setValue(_ value: AnyObject) {
        SettingsManager.saveData(value, key: self.rawValue)
    }
}

class SettingsManager {
    
    // MARK: - Class Function
    
    class func getData(_ key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    class func saveData(_ object: AnyObject, key: String) {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
