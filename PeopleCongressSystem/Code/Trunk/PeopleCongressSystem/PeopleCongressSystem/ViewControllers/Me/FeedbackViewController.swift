//
//  FeedbackViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/8.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        CustomObjectUtil.customObjectsLayout([submitButton], backgroundColor: colorRed, borderWidth: 0, borderColor: nil, corner: 5.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func clickSubmit(sender: AnyObject) {
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
