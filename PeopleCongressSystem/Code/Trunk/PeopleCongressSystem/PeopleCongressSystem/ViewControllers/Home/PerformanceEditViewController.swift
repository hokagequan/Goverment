//
//  PerformanceEditViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/20.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class PerformanceEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum EditSections: Int {
        case MainContent = 0
        case Time
        case Detail
        case Persons
        case Max
    }
    
    enum MainRows: Int {
        case Title = 0
        case Type
        case Organization
        case Max
        
        func title() -> String {
            let titles = ["标题:", "类型:", "组织:"]
            
            return titles[self.rawValue]
        }
        
        func icons() -> String {
            let icons = ["title", "type", "organization"]
            
            return icons[self.rawValue]
        }
    }
    
    enum TimeRows: Int {
        case Time = 0
        case Max
        
        func title() -> Array<String> {
            let titles = [["开始时间:", "结束时间:"]]
            
            return titles[self.rawValue]
        }
        
        func icons() -> Array<String> {
            let icons = [["time", ""]]
            
            return icons[self.rawValue]
        }
    }
    
    enum DetailRows: Int {
        case Detail = 0
        case Max
        
        func title() -> Array<String> {
            let titles = [["地址:", "内容:"]]
            
            return titles[self.rawValue]
        }
        
        func icons() -> Array<String> {
            let icons = [["location", "content"]]
            
            return icons[self.rawValue]
        }
    }
    
    enum PersonsRows: Int {
        case Person = 0
        case Max
        
        func title() -> String {
            let titles = ["人员:"]
            
            return titles[self.rawValue]
        }
        
        func icons() -> String {
            let icons = ["person"]
            
            return icons[self.rawValue]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cellForMainRow(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NormalImageTableCell", forIndexPath: indexPath) as! NormalImageTableCell
        
        let row = MainRows(rawValue: indexPath.row)!
        
        cell.iconImageView.image = UIImage(named: row.icons())
        cell.headerText = row.title()
        
        switch row {
        case .Title:
            cell.accessoryType = UITableViewCellAccessoryType.None
            break
        case .Organization:
            cell.accessoryType = UITableViewCellAccessoryType.None
            break
        case .Type:
            cell.editable = false
            break
        default:
            break
        }
        
        return cell
    }
    
    func cellForTimeRow(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DoubleContentCell", forIndexPath: indexPath) as! DoubleContentCell
        
        let row = TimeRows(rawValue: indexPath.row)!
        
        cell.iconUpImageView.image = UIImage(named: row.icons()[0])
        cell.iconDownImageView.image = UIImage(named: row.icons()[1])
        cell.headerUpText = row.title()[0]
        cell.headerDownText = row.title()[1]
        
        return cell
    }
    
    func cellForDetailRow(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DoubleContentCell", forIndexPath: indexPath) as! DoubleContentCell
        
        let row = DetailRows(rawValue: indexPath.row)!
        
        cell.iconUpImageView.image = UIImage(named: row.icons()[0])
        cell.iconDownImageView.image = UIImage(named: row.icons()[1])
        cell.headerUpText = row.title()[0]
        cell.headerDownText = row.title()[1]
        
        return cell
    }
    
    func cellForPersonRow(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TagListCell", forIndexPath: indexPath) as! TagListCell
        
        let row = PersonsRows(rawValue: indexPath.row)!
        
        cell.iconImageView.image = UIImage(named: row.icons())
        cell.titleLabel.text = row.title()
        
        return cell
    }
    
    // MARK: - UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return EditSections.Max.rawValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec = EditSections(rawValue: section)!
        
        switch sec {
        case EditSections.MainContent:
            return MainRows.Max.rawValue
        case EditSections.Time:
            return TimeRows.Max.rawValue
        case EditSections.Detail:
            return DetailRows.Max.rawValue
        case EditSections.Persons:
            return PersonsRows.Max.rawValue
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // TODO: 计算Cell高度
        let section = EditSections(rawValue: indexPath.section)!
        
        switch section {
        case .Time:
            return 88.0
        case .Detail:
            return 88.0
        case .Persons:
            return TagListCell.cellHeight(nil)
        default:
            break
        }
        
        return 44.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sec = EditSections(rawValue: indexPath.section)!
        
        switch sec {
        case EditSections.MainContent:
            return self.cellForMainRow(indexPath)
        case EditSections.Time:
            return self.cellForTimeRow(indexPath)
        case EditSections.Detail:
            return self.cellForDetailRow(indexPath)
        case EditSections.Persons:
            return self.cellForPersonRow(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsMake(0, 39, 0, 0)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
