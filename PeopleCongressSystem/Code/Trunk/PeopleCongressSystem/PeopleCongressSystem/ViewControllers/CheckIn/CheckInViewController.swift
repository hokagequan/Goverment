//
//  CheckInViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/6.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class CheckInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
    var activitys = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PCSCustomUtil.customNavigationController(self)
        
        listTableView.registerNib(UINib(nibName: "NormalInfoCell", bundle: nil), forCellReuseIdentifier: "NormalInfoCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getActivityList("") { (info, errorCode) -> Void in
            EZLoadingActivity.hide()
            if info != nil {
                self.activitys = info!
                self.listTableView.reloadData()
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitys.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.contentView.viewWithTag(1000) != nil {
            return
        }
        
        let frame = CGRectMake(5, 4, cell.bounds.size.width - 10, cell.bounds.size.height - 8)
        let view = UIView(frame: frame)
        view.tag = 1000
        CustomObjectUtil.customObjectsLayout([view], backgroundColor: UIColor.whiteColor(), borderWidth: 1, borderColor: GlobalUtil.colorRGBA(240, g: 240, b: 240, a: 1.0), corner: 2)
        cell.contentView.addSubview(view)
        cell.contentView.sendSubviewToBack(view)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NormalInfoCell", forIndexPath: indexPath) as! NormalInfoCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let activity = activitys[indexPath.row]
        cell.titleLabel.text = activity.title
        cell.locationLabel.text = activity.organization
        cell.dateLabel.text = activity.beginTime?.substringToIndex(activity.beginTime!.startIndex.advancedBy(10))
        cell.backgroundColor = UIColor.clearColor()
        cell.iconImageView.hidden = true
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PerformanceEditViewController") as! PerformanceEditViewController
        vc.pageType = EditPageType.CheckIn
        let activity = activitys[indexPath.row]
        vc.editObject = activity.copy()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
