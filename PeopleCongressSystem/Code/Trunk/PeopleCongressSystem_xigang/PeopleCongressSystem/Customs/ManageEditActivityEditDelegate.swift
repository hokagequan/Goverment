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
        
        let group = DispatchGroup()
        let semaphore = DispatchSemaphore(value: 1)
        let queue = DispatchQueue(label: "GetActivityDetail", attributes: [])
        
        EZLoadingActivity.show("", disableUI: true)
        
        queue.async { () -> Void in
            group.enter()
            semaphore.wait(timeout: DispatchTime.distantFuture)
            PCSDataManager.defaultManager().getPersonList("\((self.editObject as! Activity).identifier)") { (info, errorCode) -> Void in
                (self.editObject as! Activity).persons = info
                semaphore.signal()
                //            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 3)], withRowAnimation: UITableViewRowAnimation.None)
            }
            
            semaphore.wait(timeout: DispatchTime.distantFuture)
            let gapReq = GetActivityPersonsReq()
            gapReq.activity = self.editObject as? Activity
            gapReq.requestSimpleCompletion { (info, errorCode) -> Void in
                for person in (self.editObject as! Activity).persons! {
                    person.organization = info[person.organizationID!]
                }
                
                semaphore.signal()
                group.leave()
            }
            
            group.enter()
            let req = GetActivityDetaildReq()
            req.activity = self.editObject as? Activity
            req.requestSimpleCompletion { (success, errorCode) -> Void in
                group.leave()
            }
            
            group.notify(queue: DispatchQueue.main) { () -> Void in
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
        req.requestSimpleCompletion { (success, message, errorCode) -> Void in
            EZLoadingActivity.hide()
            if success == true {
                GlobalUtil.showAlert(message!)
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: message)
            }
        }
    }
    
}
