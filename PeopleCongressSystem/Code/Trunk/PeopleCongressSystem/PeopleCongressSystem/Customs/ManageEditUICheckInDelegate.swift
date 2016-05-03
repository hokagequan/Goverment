//
//  ManageEditUICheckInDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/7.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit
import SwiftQRCode

class ManageEditUICheckInDelegate: ManageEditActivityEditDelegate {
    
    var qrImage: UIImage? = nil
    
    override func prepare() {
        super.prepare()
        // 生成二维码
        var codeString = "Non"
        
        let activity = (self.masterViewController as! PerformanceEditViewController).editObject as? Activity
        if activity != nil {
            codeString = "\(activity!.identifier):\(QRCodeType.ActivityID.rawValue)"
        }
        qrImage = QRCode.generateImage(codeString, avatarImage: nil)
    }
    
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == EditSections.Max.rawValue {
            return 180
        }
        
        if indexPath.section == EditSections.Persons.rawValue {
            return 44 + 5 + 44
        }
        
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == EditSections.Max.rawValue {
            let cell = tableView.dequeueReusableCellWithIdentifier("QRCodeCell", forIndexPath: indexPath) as! QRCodeCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.qrCodeImageView.image = qrImage
            
            return cell
        }
        
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        cell.userInteractionEnabled = false
        
        if cell is TagListCell {
            var array = [String]()
            let activity = (self.masterViewController as! PerformanceEditViewController).editObject as? Activity
            if activity != nil {
                array.append("应到:\(activity!.totalPersonCount)")
                array.append("实到:\(activity!.checkedInPersonCount)")
                array.append("未到:\(activity!.totalPersonCount - activity!.checkedInPersonCount)")
                (cell as! TagListCell).customTagSize(CGSizeMake(60, 40))
                (cell as! TagListCell).loadInfo(array)
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}