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
        case mainContent = 0
        case time
        case detail
        case persons
        case max
        
        func rows() -> Array<Row> {
            let titles = [["标题:", "类型:", "组织单位:"],
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
    
    func cellForMainRow(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView!.dequeueReusableCell(withIdentifier: "NormalImageTableCell", for: indexPath) as! NormalImageTableCell
        
        let sec = EditSections(rawValue: (indexPath as NSIndexPath).section)!
        let row = sec.rows()[(indexPath as NSIndexPath).row]
        cell.iconImageView.image = UIImage(named: row.icon!)
        cell.headerText = row.title as NSString?
        cell.delegate = self
        cell.editable = true
        cell.timeEditable = false
        
        switch row.title! {
        case "类型:":
            cell.editable = false
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            break
        case "开始时间:", "结束时间:":
            cell.timeEditable = true
            break
        default:
            cell.accessoryType = UITableViewCellAccessoryType.none
            break
        }
        
        return cell
    }
    
    func cellForPersonRow(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView!.dequeueReusableCell(withIdentifier: "TagListCell", for: indexPath) as! TagListCell
        
        let sec = EditSections(rawValue: (indexPath as NSIndexPath).section)!
        let row = sec.rows()[(indexPath as NSIndexPath).row]
        
        cell.iconImageView.image = UIImage(named: row.icon!)
        cell.titleLabel.text = row.title
        
        return cell
    }
    
    func prepare() {}
    
    func save() {}
    
    // MARK: - NormalImageTableCellDelegate
    
    func didEditing(_ cell: NormalImageTableCell) {
        tableView?.isScrollEnabled = false
        let keyboardHeight: CGFloat = 246.0
        let deltaY = cell.frame.origin.y + 50.0 - (tableView!.bounds.size.height - keyboardHeight) + tableView!.frame.origin.y
        
        if deltaY > 0 {
            tableView?.setContentOffset(CGPoint(x: 0, y: deltaY), animated: true)
        }
    }
    
    func didEndEditing(_ cell: NormalImageTableCell) {
        tableView?.setContentOffset(CGPoint.zero, animated: true)
        tableView?.isScrollEnabled = true
    }
    
    func didEditingTime(_ cell: NormalImageTableCell, datePicker: DatePickerView) {
        masterViewController?.view.endEditing(true)
        let keyboardHeight: CGFloat = datePicker.datePickerContainer.bounds.size.height
        let deltaY = cell.frame.origin.y + 50.0 - (tableView!.bounds.size.height - keyboardHeight) + tableView!.frame.origin.y
        
        if deltaY > 0 {
            tableView?.setContentOffset(CGPoint(x: 0, y: deltaY), animated: true)
        }
    }
    
    func didEndEditingTime(_ cell: NormalImageTableCell) {
        tableView?.setContentOffset(CGPoint.zero, animated: true)
    }
    
    // MARK: - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EditSections.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = EditSections(rawValue: section)!
        
        return sec.rows().count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = EditSections(rawValue: (indexPath as NSIndexPath).section)!
        let row = section.rows()[(indexPath as NSIndexPath).row]
        
        switch row.title! {
        case "人员:":
            return 44.0
        default:
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = EditSections(rawValue: (indexPath as NSIndexPath).section)!
        let row = section.rows()[(indexPath as NSIndexPath).row]
        
        switch row.title! {
        case "人员:":
            return self.cellForPersonRow(indexPath)
        default:
            return self.cellForMainRow(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsetsMake(0, 39, 0, 0)
    }
    
}
