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
    case activity
    case activityEdit
    case variable
    case checkIn
    
    func customNavi(_ naviView: PCSNavigationView, rightNaviButton: UIButton) {
        switch self {
        case .activity:
            naviView.title = "添加活动"
            break
        case .activityEdit:
            naviView.title = "活动详情"
            break
        case .checkIn:
            naviView.title = "签到"
            rightNaviButton.setTitle("", for: UIControlState())
            rightNaviButton.setImage(UIImage(named: "qr_scan"), for: UIControlState())
            break
        default:
            break
        }
    }
    
    func loadDelegate(_ viewController: PerformanceEditViewController, tableView: UITableView) -> ManageEditUIDelegate {
        func loadTableView(_ viewController: PerformanceEditViewController, delegate: ManageEditUIDelegate, tableView: UITableView) {
            delegate.tableView = tableView
            tableView.dataSource = delegate
            tableView.delegate = delegate
            delegate.masterViewController = viewController
        }
        
        switch self {
        case .activity:
            let delegate = ManageEditUIActivityDelegate()
            loadTableView(viewController, delegate: delegate, tableView: tableView)
            
            return delegate
        case .activityEdit:
            let delegate = ManageEditActivityEditDelegate()
            loadTableView(viewController, delegate: delegate, tableView: tableView)
            
            return delegate
        case .checkIn:
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardListener(#selector(self.handleKeyboardChange(_:)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 3)], with: UITableViewRowAnimation.none)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unregisterKeyboardListener()
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(_ sender: AnyObject) {
        myUIDelegate?.save()
    }
    
    // MARK: - Observer
    
    func handleKeyboardChange(_ notification: Notification) {
        guard let info = notification.object as? KeyboardInfo else {
            return
        }
        
        UIView.animate(withDuration: info.duration, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) 
    }

    // MARK: - Navigation
    
    @IBAction func unwindToActivityDetail(_ segue: UIStoryboardSegue) {
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GroupSegue" {
            let vc = segue.destination as! GroupViewController
            vc.activity = myUIDelegate?.editObject as? Activity
        }
        else if segue.identifier == "UnCheckedInListSegue" {
            let vc = segue.destination as! UnCheckedInListViewController
            if self.editObject != nil && self.editObject is Activity {
                vc.activityID = (self.editObject as! Activity).identifier
            }
        }
    }

}
