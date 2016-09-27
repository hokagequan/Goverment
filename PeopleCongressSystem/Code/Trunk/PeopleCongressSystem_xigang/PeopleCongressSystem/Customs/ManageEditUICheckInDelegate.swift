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
        let vc = storyboard.instantiateViewController(withIdentifier: "QRCodeScanViewController") as! QRCodeScanViewController
        vc.activity = (self.masterViewController as! PerformanceEditViewController).editObject as? Activity
        self.masterViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return super.numberOfSections(in: tableView) + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == EditSections.max.rawValue {
            return 1
        }
        else if section == EditSections.persons.rawValue {
            return 2
        }
        
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == EditSections.max.rawValue {
            return 180
        }
        
        if (indexPath as NSIndexPath).section == EditSections.persons.rawValue {
            if (indexPath as NSIndexPath).row == 0 {
                return 44 + 5 + 44
            }
            else if (indexPath as NSIndexPath).row == 1 {
                return 44
            }
        }
        
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == EditSections.max.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QRCodeCell", for: indexPath) as! QRCodeCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.qrCodeImageView.image = qrImage
            
            return cell
        }
        
        if (indexPath as NSIndexPath).section == EditSections.persons.rawValue && (indexPath as NSIndexPath).row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NormalImageTableCell", for: indexPath) as! NormalImageTableCell
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            let sec = EditSections(rawValue: (indexPath as NSIndexPath).section)!
            let row = sec.rows()[0]
            cell.iconImageView.image = UIImage(named: row.icon!)
            cell.headerText = "未签到列表"
            cell.delegate = self
            cell.editable = false
            cell.timeEditable = false
            
            return cell
        }
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.isUserInteractionEnabled = false
        
        if cell is TagListCell {
            var array = [String]()
            let activity = (self.masterViewController as! PerformanceEditViewController).editObject as? Activity
            if activity != nil {
                array.append("应到:\(activity!.totalPersonCount)")
                array.append("实到:\(activity!.checkedInPersonCount)")
                array.append("未到:\(activity!.totalPersonCount - activity!.checkedInPersonCount)")
                (cell as! TagListCell).customTagSize(CGSize(width: 60, height: 40))
                (cell as! TagListCell).loadInfo(array)
                (cell as! TagListCell).indicatorImageView.isHidden = true
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if (indexPath as NSIndexPath).section == EditSections.persons.rawValue && (indexPath as NSIndexPath).row == 1 {
            self.masterViewController?.performSegue(withIdentifier: "UnCheckedInListSegue", sender: self)
        }
    }
    
}
