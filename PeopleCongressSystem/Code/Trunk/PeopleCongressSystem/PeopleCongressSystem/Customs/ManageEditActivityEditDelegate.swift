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
        
        let group = dispatch_group_create()
        let semaphore = dispatch_semaphore_create(1)
        let queue = dispatch_queue_create("GetActivityDetail", nil)
        
        EZLoadingActivity.show("", disableUI: true)
        
        dispatch_async(queue) { () -> Void in
            dispatch_group_enter(group)
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            PCSDataManager.defaultManager().getPersonList("\((self.editObject as! Activity).identifier)") { (info) -> Void in
                (self.editObject as! Activity).persons = info
                dispatch_semaphore_signal(semaphore)
                //            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 3)], withRowAnimation: UITableViewRowAnimation.None)
            }
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            let gapReq = GetActivityPersonsReq()
            gapReq.activity = self.editObject as? Activity
            gapReq.requestSimpleCompletion { (info) -> Void in
                for person in (self.editObject as! Activity).persons! {
                    person.organization = info[person.organizationID!]
                }
                
                dispatch_semaphore_signal(semaphore)
                dispatch_group_leave(group)
            }
            
            dispatch_group_enter(group)
            let req = GetActivityDetaildReq()
            req.activity = self.editObject as? Activity
            req.requestSimpleCompletion { (success) -> Void in
                dispatch_group_leave(group)
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
                EZLoadingActivity.hide()
                self.tableView?.reloadData()
            }
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