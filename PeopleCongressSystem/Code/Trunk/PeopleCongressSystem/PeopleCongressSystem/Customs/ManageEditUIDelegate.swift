//
//  ManageEditUIDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/5.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class ManageEditUIDelegate: NSObject, UITableViewDataSource, UITableViewDelegate, NormalImageTableCellDelegate, TypeSelectViewDelegate {
    
    weak var masterViewController: UIViewController?
    weak var tableView: UITableView?
    
    var editObject: AnyObject? = nil

    enum EditSections: Int {
        case MainContent = 0
        case Time
        case Detail
        case Persons
        case Max
        
        func rows() -> Array<Row> {
            let titles = [["标题:", "类型:", "组织:"],
                ["开始时间:", "结束时间:"],
                ["地址:", "内容:"],
                ["人员:"]
            ]
            
            let icons = [["title", "type", "organization"],
                ["time", ""],
                ["location", "content"],
                ["person"]
            ]
            
            let keys = [["title", "typeTitle", "organization"],
                ["beginTime", "endTime"],
                ["location", "content"],
                ["persons"]
            ]
            
            if self.rawValue >= titles.count {
                return [Row]()
            }
            
            var rows = [Row]()
            let rowTitles = titles[self.rawValue]
            for i in 0..<rowTitles.count {
                var row = Row()
                row.title = rowTitles[i]
                row.icon = icons[self.rawValue][i]
                row.key = keys[self.rawValue][i]
                rows.append(row)
            }
            
            return rows
        }
    }
    
    struct Row {
        
        var title: String? = nil
        var icon: String? = nil
        var key: String? = nil
        
    }
    
    func cellForMainRow(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView!.dequeueReusableCellWithIdentifier("NormalImageTableCell", forIndexPath: indexPath) as! NormalImageTableCell
        
        let sec = EditSections(rawValue: indexPath.section)!
        let row = sec.rows()[indexPath.row]
        cell.iconImageView.image = UIImage(named: row.icon!)
        cell.headerText = row.title
        cell.delegate = self
        cell.editable = true
        cell.timeEditable = false
        
        switch row.title! {
        case "类型:":
            cell.editable = false
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            break
        case "开始时间:", "结束时间:":
            cell.timeEditable = true
            break
        default:
            cell.accessoryType = UITableViewCellAccessoryType.None
            break
        }
        
        return cell
    }
    
    func cellForPersonRow(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView!.dequeueReusableCellWithIdentifier("TagListCell", forIndexPath: indexPath) as! TagListCell
        
        let sec = EditSections(rawValue: indexPath.section)!
        let row = sec.rows()[indexPath.row]
        
        cell.iconImageView.image = UIImage(named: row.icon!)
        cell.titleLabel.text = row.title
        
        return cell
    }
    
    func prepare() {}
    
    func save() {}
    
    // MARK: - NormalImageTableCellDelegate
    
    func didEditing(cell: NormalImageTableCell) {
        tableView?.scrollEnabled = false
        let keyboardHeight: CGFloat = 246.0
        let deltaY = cell.frame.origin.y + 50.0 - (tableView!.bounds.size.height - keyboardHeight) + tableView!.frame.origin.y
        
        if deltaY > 0 {
            tableView?.setContentOffset(CGPointMake(0, deltaY), animated: true)
        }
    }
    
    func didEndEditing(cell: NormalImageTableCell) {
        tableView?.setContentOffset(CGPointZero, animated: true)
        tableView?.scrollEnabled = true
    }
    
    func didEditingTime(cell: NormalImageTableCell, datePicker: DatePickerView) {
        masterViewController?.view.endEditing(true)
        let keyboardHeight: CGFloat = datePicker.datePickerContainer.bounds.size.height
        let deltaY = cell.frame.origin.y + 50.0 - (tableView!.bounds.size.height - keyboardHeight) + tableView!.frame.origin.y
        
        if deltaY > 0 {
            tableView?.setContentOffset(CGPointMake(0, deltaY), animated: true)
        }
    }
    
    func didEndEditingTime(cell: NormalImageTableCell) {
        tableView?.setContentOffset(CGPointZero, animated: true)
    }
    
    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return EditSections.Max.rawValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = EditSections(rawValue: section)!
        
        return sec.rows().count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let section = EditSections(rawValue: indexPath.section)!
        let row = section.rows()[indexPath.row]
        
        switch row.title! {
        case "人员:":
            return 44.0
        default:
            return 50.0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = EditSections(rawValue: indexPath.section)!
        let row = section.rows()[indexPath.row]
        
        switch row.title! {
        case "人员:":
            return self.cellForPersonRow(indexPath)
        default:
            return self.cellForMainRow(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsMake(0, 39, 0, 0)
    }
    
}
