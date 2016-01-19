//
//  PCSDataManager.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

class PCSDataManager {
    
    static let _pcsDataManager = PCSDataManager()
    
    var accountManager = AccountManager()
    
    // MARK: - Class Functions
    
    class func defaultManager() -> PCSDataManager {
        return _pcsDataManager;
    }
    
}
