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
    
    func registerKeyboardListener(_ handler: Selector) {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.handleKeyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.handleKeyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.handleKeyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: handler, name: NSNotification.Name(rawValue: "SGKeyboardChanged"), object: nil)
    }
    
    func unregisterKeyboardListener() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardBoundsValue = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let duration = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let info = KeyboardInfo()
        info.height = keyboardBoundsValue.cgRectValue.height
        info.duration = duration.doubleValue
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SGKeyboardChanged"), object:info)
    }
    
    func handleKeyboardHide(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo
        let duration = userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        
        let info = KeyboardInfo()
        info.height = 0
        info.duration = duration.doubleValue
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SGKeyboardChanged"), object: info)
    }
    
}
