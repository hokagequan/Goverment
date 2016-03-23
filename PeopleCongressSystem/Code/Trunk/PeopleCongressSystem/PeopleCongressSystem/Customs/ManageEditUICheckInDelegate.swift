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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.userInteractionEnabled = false
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}