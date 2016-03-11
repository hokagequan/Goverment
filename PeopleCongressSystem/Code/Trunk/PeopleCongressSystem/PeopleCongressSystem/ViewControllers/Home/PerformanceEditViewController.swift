//
//  PerformanceEditViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/20.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

enum EditPageType {
    case Activity
    case ActivityEdit
    case Variable
    case CheckIn
    
    func customNavi(naviView: PCSNavigationView, rightNaviButton: UIButton) {
        switch self {
        case .CheckIn:
            naviView.title = "签到"
            rightNaviButton.setTitle("", forState: UIControlState.Normal)
            rightNaviButton.setImage(UIImage(named: "qr_scan"), forState: UIControlState.Normal)
            break
        default:
            break
        }
    }
    
    func loadDelegate(viewController: PerformanceEditViewController, tableView: UITableView) -> ManageEditUIDelegate {
        func loadTableView(viewController: PerformanceEditViewController, delegate: ManageEditUIDelegate, tableView: UITableView) {
            delegate.tableView = tableView
            tableView.dataSource = delegate
            tableView.delegate = delegate
            delegate.masterViewController = viewController
        }
        
        switch self {
        case .Activity:
            let delegate = ManageEditUIActivityDelegate()
            loadTableView(viewController, delegate: delegate, tableView: tableView)
            
            return delegate
        case .ActivityEdit:
            let delegate = ManageEditActivityEditDelegate()
            loadTableView(viewController, delegate: delegate, tableView: tableView)
            
            return delegate
        case .CheckIn:
            let delegate = ManageEditUICheckInDelegate()
            loadTableView(viewController, delegate: delegate, tableView: tableView)
            
            return delegate
        default:
            return ManageEditUIDelegate()
        }
    }
}

class PerformanceEditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var naviView: PCSNavigationView!
    @IBOutlet weak var rightNaviButton: UIButton!
    
    var editObject: AnyObject? = nil
    var myUIDelegate: ManageEditUIDelegate? = nil
    var pageType: EditPageType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        pageType?.customNavi(naviView, rightNaviButton: rightNaviButton)
        myUIDelegate = pageType?.loadDelegate(self, tableView: tableView)
        myUIDelegate?.editObject = editObject
        myUIDelegate?.prepare()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardListener(Selector("handleKeyboardChange:"))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 3)], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.unregisterKeyboardListener()
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(sender: AnyObject) {
        myUIDelegate?.save()
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GroupSegue" {
            let vc = segue.destinationViewController as! GroupViewController
            vc.activity = myUIDelegate?.editObject as? Activity
        }
    }

}
