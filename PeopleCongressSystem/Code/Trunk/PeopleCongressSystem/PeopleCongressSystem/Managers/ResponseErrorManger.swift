//
//  ResponseErrorManger.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/8.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

class ResponseErrorManger: NSObject, UIAlertViewDelegate {
    
    static let _responseErrorManager = ResponseErrorManger()
    
    func handleError(code: String?, message: String?) {
        
        if message == nil && code == nil {
            return
        }
        
        if code == "-1" {
            let alert = UIAlertView(title: "", message: "尊敬的人大代表，您的账号已在另外一台可信设备上登录，请重新登录", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "登录")
            alert.show()
            
            return
        }
        
        if message == nil || message?.characters.count == 0 {
            return
        }
        
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    // MARK: - Class Function
    
    class func defaultManager() -> ResponseErrorManger {
        return _responseErrorManager
    }
    
    // MARK: - AlertView
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            NSNotificationCenter.defaultCenter().postNotificationName(kNotificationPresentLogin, object: nil)
        }
    }
    
}