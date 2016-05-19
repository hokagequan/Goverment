//
//  PCSEaseUserModel.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/5/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation

extension EaseUserModel {
    
    private struct AssociatedKeys {
        static var pcsName = "pcsName"
        static var pcsPhotoName = "pcsPhotoName"
    }
    
    var pcsName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.pcsName) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pcsName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pcsPhotoName: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.pcsPhotoName) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.pcsPhotoName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
