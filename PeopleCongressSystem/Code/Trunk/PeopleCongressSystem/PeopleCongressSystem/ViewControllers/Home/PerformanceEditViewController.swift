//
//  PerformanceEditViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/20.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class PerformanceEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NormalImageTableCellDelegate, TypeSelectViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var activity: Activity = Activity()
    var selectedType: PCSTypeInfo? = nil
    
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
            
            let keys = [["title", "type", "organization"],
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardListener(Selector("handleKeyboardChange:"))
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unregisterKeyboardListener()
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createActivity() -> Activity {
        for section in 0..<EditSections.Max.rawValue {
            let sec = EditSections(rawValue: section)
            let rowCount = sec?.rows().count
            
            for row in 0..<rowCount! {
                let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section))
                if cell is NormalImageTableCell {
                    let row = sec!.rows()[row]
                    activity.setValue((cell as! NormalImageTableCell).titleTextField.text, forKey: row.key!)
                }
            }
        }
        
        return activity
    }
    
    func cellForMainRow(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NormalImageTableCell", forIndexPath: indexPath) as! NormalImageTableCell
        
        let sec = EditSections(rawValue: indexPath.section)!
        let row = sec.rows()[indexPath.row]
        cell.iconImageView.image = UIImage(named: row.icon!)
        cell.headerText = row.title
        cell.delegate = self
        
        switch row.title! {
        case "类型:":
            cell.editable = false
            cell.titleTextField.text = selectedType?.title
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            break
        default:
            cell.accessoryType = UITableViewCellAccessoryType.None
            break
        }
        
        return cell
    }
    
    func cellForPersonRow(indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TagListCell", forIndexPath: indexPath) as! TagListCell
        
        let sec = EditSections(rawValue: indexPath.section)!
        let row = sec.rows()[indexPath.row]
        
        cell.iconImageView.image = UIImage(named: row.icon!)
        cell.titleLabel.text = row.title
        
        return cell
    }
    
    func verify() -> Bool {
        if activity.title == nil {
            self.showAlert("请填写标题")
            
            return false
        }
        
        if activity.type == nil {
            self.showAlert("请选择类型")
            
            return false
        }
        
        if activity.organization == nil {
            self.showAlert("请填写组织")
            
            return false
        }
        
        if activity.beginTime == nil {
            self.showAlert("请填写开始时间")
            
            return false
        }
        
        if activity.endTime == nil {
            self.showAlert("请填写结束时间")
            
            return false
        }
        
        if activity.location == nil {
            self.showAlert("请填写地点")
            
            return false
        }
        
        if activity.content == nil {
            self.showAlert("请填写内容")
            
            return false
        }
        
        if activity.persons?.count == 0 {
            self.showAlert("请选择人员")
            
            return false
        }
        
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(sender: AnyObject) {
        if self.verify() == false {
            return
        }
        
        EZLoadingActivity.show("", disableUI: true)
        self.createActivity()
        PCSDataManager.defaultManager().addActivity(activity) { (success, message) -> Void in
            EZLoadingActivity.hide()
            
            if success {
                self.showAlert("添加成功")
            }
            else {
                self.showAlert(message!)
            }
        }
    }
    
    // MARK: - Observer
    
    func handleKeyboardChange(notification: NSNotification) {
        guard let info = notification.object as? KeyboardInfo else {
            return
        }
        
        UIView.animateWithDuration(info.duration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - TypeSelectViewDelegate
    
    func didSelectType(view: TypeSelectView, type: PCSTypeInfo) {
        selectedType = type
        tableView.reloadData()
    }
    
    // MARK: - NormalImageTableCellDelegate
    
    func didEditing(cell: NormalImageTableCell) {
        let indexPath = tableView.indexPathForCell(cell)!
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
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
        // TODO: 计算Cell高度
        let section = EditSections(rawValue: indexPath.section)!
        let row = section.rows()[indexPath.row]
        
        switch row.title! {
        case "人员:":
            return TagListCell.cellHeight(nil)
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = EditSections(rawValue: indexPath.section)!
        let row = section.rows()[indexPath.row]
        
        switch row.title! {
        case "类型:":
            let typeView = TypeSelectView.view()
            typeView.delegate = self
            typeView.show(PCSType.Congress)
            
            break
        case "人员:":
            self.performSegueWithIdentifier("GroupSegue", sender: self)
            break
        default:
            break
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GroupSegue" {
            let vc = segue.destinationViewController as! GroupViewController
            vc.activity = activity
        }
    }

}
