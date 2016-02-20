//
//  GestureLockViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import HUIPatternLockView_Swift

class GestureLockViewController: UIViewController {

    @IBOutlet weak var lockView: HUIPatternLockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.customLockView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PCSCustomUtil.customNavigationController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customLockView() {
        let defaultLineColor = HUIPatternLockView.defaultLineColor
        let correctLineColor = UIColor.greenColor()
        let wrongLineColor = UIColor.redColor()
        
        let normalImage = UIImage(named: "gesture_dot_nor")
        let selectImage = UIImage(named: "gesture_dot_sel")
        let correctImage = UIImage(named: "gesture_dot_sel")
        let wrongImage = UIImage(named: "gesture_dot_sel")
        
        lockView.didDrawPatternWithPassword = {(lockView: HUIPatternLockView, count: Int, password: String?) -> Void in
            guard count > 0 else {
                return
            }
            
            let correctPassword = PCSDataManager.defaultManager().accountManager.user?.gesturePassword
            
            if password == correctPassword {
                lockView.lineColor = correctLineColor
                lockView.normalDotImage = correctImage
                lockView.highlightedDotImage = correctImage
            }
            else {
                lockView.lineColor = wrongLineColor
                lockView.normalDotImage = wrongImage
                lockView.highlightedDotImage = wrongImage
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                lockView.resetDotsState()
                lockView.lineColor = defaultLineColor
                lockView.normalDotImage = normalImage
                lockView.highlightedDotImage = selectImage
                
                let manager = PCSDataManager.defaultManager().accountManager
                manager.signIn(manager.user!.account!, password: manager.user!.password!) { (success, errorMessage) -> Void in
                    if success == true {
                        self.performSegueWithIdentifier("MainSegue", sender: self)
                    }
                    else {
                        self.showAlert(errorMessage)
                    }
                }
            })
        }
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
