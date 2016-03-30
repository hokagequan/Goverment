//
//  PerformanceRecordsViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

enum ManagePageType {
    case Activity
    case Variable
}

class PerformanceRecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TypeSelectViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
    var activitys = [Activity]()
    var allActivitys = [Activity]()
    var types = [PCSTypeInfo]()
    var selectedObject: AnyObject? = nil
    var selectedType: PCSTypeInfo?
    var gotoPageType: EditPageType = EditPageType.Activity
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        listTableView.registerNib(UINib(nibName: "NormalInfoCell", bundle: nil), forCellReuseIdentifier: "NormalInfoCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedObject = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getActivityList("") { (info) -> Void in
            EZLoadingActivity.hide()
            
            if info != nil {
                self.allActivitys = info!
                self.refreshTableView()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshTableView() {
        if selectedType == nil {
            activitys = allActivitys
        }
        else {
            activitys = allActivitys.filter({ (activity) -> Bool in
                return activity.type! == self.selectedType!.code!
            })
        }
        
        listTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func clickAdd(sender: AnyObject) {
        gotoPageType = EditPageType.Activity
        self.performSegueWithIdentifier("EditSegue", sender: self)
    }
    
    // MARK: - TypeSelectViewDelegate
    
    func didSelectIndex(view: TypeSelectView, indexPath: NSIndexPath) {
        selectedType = types[indexPath.row]
        
        self.refreshTableView()
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitys.count + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 52.0
        }
        
        return 83.0
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.contentView.viewWithTag(1000) != nil {
            return
        }
        
        let frame = CGRectMake(5, 4, cell.bounds.size.width - 10, cell.bounds.size.height - 8)
        let view = UIView(frame: frame)
        view.tag = 1000
        CustomObjectUtil.customObjectsLayout([view], backgroundColor: UIColor.whiteColor(), borderWidth: 1, borderColor: GlobalUtil.colorRGBA(230, g: 230, b: 230, a: 1.0), corner: 2)
        cell.contentView.addSubview(view)
        cell.contentView.sendSubviewToBack(view)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath)
            cell.imageView?.image = UIImage(named: "categroy")
            cell.textLabel?.text = "活动分类"
            
            if selectedType == nil {
                cell.detailTextLabel?.text = "请选择"
            }
            else {
                cell.detailTextLabel?.text = selectedType?.title
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("NormalInfoCell", forIndexPath: indexPath) as! NormalInfoCell
        cell.backgroundColor = UIColor.clearColor()
        
        let index = indexPath.row - 1
        let activity = activitys[index]
        cell.titleLabel.text = activity.title
        cell.locationLabel.text = activity.organization
        cell.dateLabel.text = activity.beginTime?.substringToIndex(activity.beginTime!.startIndex.advancedBy(10))
        cell.iconImageView.hidden = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            EZLoadingActivity.show("", disableUI: true)
            PCSDataManager.defaultManager().getTypeInfo(PCSType.Congress) { (infos) -> Void in
                EZLoadingActivity.hide()
                if infos != nil {
                    self.types = infos!
                    let typeView = TypeSelectView.view()
                    typeView.dataSource = self.types.flatMap({return $0.title})
                    typeView.delegate = self
                    typeView.show()
                }
            }
            
            return
        }
        
        let activity = activitys[indexPath.row - 1]
        selectedObject = activity
        gotoPageType = EditPageType.ActivityEdit
        self.performSegueWithIdentifier("EditSegue", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditSegue" {
            let vc = segue.destinationViewController as! PerformanceEditViewController
            vc.pageType = gotoPageType
            vc.editObject = selectedObject ?? Activity()
        }
    }

}
