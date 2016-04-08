//
//  ChangeGestureViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/8.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import HUIPatternLockView_Swift

class ChangeGestureViewController: UIViewController {

    @IBOutlet weak var lockView: HUIPatternLockView!
    @IBOutlet weak var naviView: PCSNavigationView!
    @IBOutlet weak var promptLabel: UILabel!
    
    var hasOldGesture = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        hasOldGesture = PCSDataManager.defaultManager().accountManager.user?.gesturePassword != nil
        
        if hasOldGesture == true {
            self.verifyOldGesture({ (success) -> Void in
                if success {
                    self.processCreatNewGesture()
                }
            })
        }
        else {
            self.processCreatNewGesture()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.customLockView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customLockView() {}
    
    func processCreatNewGesture() {
        self.drawNewGesture { (password) -> Void in
            self.verfyNewGesture(password, completion: { (success, message) -> Void in
                self.showAlert(message)
                if success {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else {
                    self.processCreatNewGesture()
                }
            })
        }
    }
    
    func verifyOldGesture(completion: (Bool) -> Void) {
        promptLabel.text = "请绘制旧的解锁图案"
        lockView.didDrawPatternWithPassword = {(lockView: HUIPatternLockView, count: Int, password: String?) -> Void in
            guard count > 0 else {
                return
            }
            
            let normalImage = UIImage(named: "gesture_dot_nor")
            let selectImage = UIImage(named: "gesture_dot_sel")

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                lockView.resetDotsState()
                lockView.normalDotImage = normalImage
                lockView.highlightedDotImage = selectImage
                
                let correctPassword = PCSDataManager.defaultManager().accountManager.user?.gesturePassword
                completion(password == correctPassword)
            })
        }
    }
    
    func drawNewGesture(completion: (String) -> Void) {
        promptLabel.text = "请绘制新的解锁图案"
        lockView.didDrawPatternWithPassword = {(lockView: HUIPatternLockView, count: Int, password: String?) -> Void in
            guard count > 0 else {
                return
            }
            
            let normalImage = UIImage(named: "gesture_dot_nor")
            let selectImage = UIImage(named: "gesture_dot_sel")
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                lockView.resetDotsState()
                lockView.normalDotImage = normalImage
                lockView.highlightedDotImage = selectImage
                
                completion(password!)
            })
        }
    }
    
    func verfyNewGesture(lastPassword: String, completion:(Bool, String) -> Void) {
        promptLabel.text = "请再一次绘制解锁图案"
        lockView.didDrawPatternWithPassword = {(lockView: HUIPatternLockView, count: Int, password: String?) -> Void in
            guard count > 0 else {
                return
            }
            
            let normalImage = UIImage(named: "gesture_dot_nor")
            let selectImage = UIImage(named: "gesture_dot_sel")
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                lockView.resetDotsState()
                lockView.normalDotImage = normalImage
                lockView.highlightedDotImage = selectImage
                
                if password == lastPassword {
                    let context = CoreDataManager.defalutManager().childContext()
                    context.performBlock({ () -> Void in
                        let manager = PCSDataManager.defaultManager().accountManager
                        manager.user?.gesturePassword = password
                        manager.user?.isDefault = true
                        
                        do {
                            try context.save()
                            CoreDataManager.defalutManager().saveContext({ () -> Void in
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completion(true, "修改成功")
                                })
                            })
                        }
                        catch {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completion(false, "修改失败")
                            })
                        }
                    })
                }
                else {
                    completion(false, "两次密码不一致")
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
