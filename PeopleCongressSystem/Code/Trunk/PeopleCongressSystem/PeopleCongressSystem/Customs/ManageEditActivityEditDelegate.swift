//
//  ManageEditActivityEditDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/11.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit
import EZLoadingActivity

class ManageEditActivityEditDelegate: ManageEditUIActivityDelegate {
    
    override func prepare() {
        if self.editObject == nil {
            return
        }
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getPersonList("\((self.editObject as! Activity).identifier)") { (info) -> Void in
            EZLoadingActivity.hide()
            
            (self.editObject as! Activity).persons = info
            
            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 3)], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    override func save() {
        self.editObject = self.createActivity()
        
        if self.verify() == false {
            return
        }
        
        EZLoadingActivity.show("", disableUI: true)
        let req = EditActivityReq()
        req.activity = self.editObject as! Activity
        req.requestSimpleCompletion { (success, message) -> Void in
            EZLoadingActivity.hide()
            GlobalUtil.showAlert(message!)
        }
    }
    
}