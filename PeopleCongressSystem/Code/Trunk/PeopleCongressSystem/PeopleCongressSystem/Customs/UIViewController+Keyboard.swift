//
//  UIViewController+Keyboard.swift
//  SuperGome
//
//  Created by Q on 15/11/6.
//  Copyright © 2015年 EADING. All rights reserved.
//

import Foundation
import UIKit

class KeyboardInfo: NSObject {
    var height: CGFloat = 0.0
    var duration: Double = 0.0
}

extension UIViewController {
    
    func registerKeyboardListener(handler: Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardShow:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: handler, name: "SGKeyboardChanged", object: nil)
    }
    
    func unregisterKeyboardListener() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleKeyboardShow(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardBoundsValue = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let duration = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let info = KeyboardInfo()
        info.height = keyboardBoundsValue.CGRectValue().height
        info.duration = duration.doubleValue
        
        NSNotificationCenter.defaultCenter().postNotificationName("SGKeyboardChanged", object:info)
    }
    
    func handleKeyboardHide(notification: NSNotification) {
        let userInfo = notification.userInfo
        let duration = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let info = KeyboardInfo()
        info.height = 0
        info.duration = duration.doubleValue
        
        NSNotificationCenter.defaultCenter().postNotificationName("SGKeyboardChanged", object: info)
    }
    
}