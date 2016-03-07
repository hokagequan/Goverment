//
//  PerformanceRecordsViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import TagListView

enum ManagePageType {
    case Activity
    case Variable
}

class PerformanceRecordsViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PCSCustomUtil.customNavigationController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickAdd(sender: AnyObject) {
        self.performSegueWithIdentifier("EditSegue", sender: self)
    }
    
    
    // MARK: - UITableView

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditSegue" {
            let vc = segue.destinationViewController as! PerformanceEditViewController
            vc.pageType = EditPageType.Activity
        }
    }

}
