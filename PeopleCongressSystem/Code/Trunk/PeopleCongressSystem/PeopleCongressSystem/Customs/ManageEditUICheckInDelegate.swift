//
//  ManageEditUICheckInDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/7.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

class ManageEditUICheckInDelegate: ManageEditActivityEditDelegate {
    
    override func save() {
        let storyboard = UIStoryboard(name: "CheckIn", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("QRCodeScanViewController") as! QRCodeScanViewController
        vc.activity = (self.masterViewController as! PerformanceEditViewController).editObject as? Activity
        self.masterViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return super.numberOfSectionsInTableView(tableView) + 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == EditSections.Max.rawValue {
            return 1
        }
        
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO: 签到二维码
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.userInteractionEnabled = false
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}