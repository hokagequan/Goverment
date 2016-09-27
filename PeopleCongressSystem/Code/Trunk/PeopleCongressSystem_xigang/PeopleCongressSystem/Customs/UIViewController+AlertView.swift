//
//  UIViewController+AlertView.swift
//  SuperGome
//
//  Created by Q on 15/10/29.
//  Copyright © 2015年 EADING. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(_ message: String) {
        let alert = UIAlertView(title: nil, message: message, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    func showAlertWithDelegate(_ message: String) {
        let alert = UIAlertView(title: nil, message: message, delegate: self, cancelButtonTitle: "确定")
        alert.show()
    }
    
}
