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
    case Variable
    
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
        default:
            return ManageEditUIDelegate()
        }
    }
}

class PerformanceEditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var editObject: AnyObject? = nil
    var myUIDelegate: ManageEditUIDelegate? = nil
    var pageType: EditPageType? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        myUIDelegate = pageType?.loadDelegate(self, tableView: tableView)
        myUIDelegate?.editObject = editObject
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerKeyboardListener(Selector("handleKeyboardChange:"))
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        let typeView = TypeSelectView.view()
//        typeView.delegate = self
//        typeView.showInView(self.view)
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
            vc.activity = editObject as? Activity
        }
    }

}
