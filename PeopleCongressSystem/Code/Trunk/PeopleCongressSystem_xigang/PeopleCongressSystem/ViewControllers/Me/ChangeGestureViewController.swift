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
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    override func viewDidAppear(_ animated: Bool) {
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
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.processCreatNewGesture()
                }
            })
        }
    }
    
    func verifyOldGesture(_ completion: @escaping (Bool) -> Void) {
        promptLabel.text = "请绘制旧的解锁图案"
        lockView.didDrawPatternWithPassword = {(lockView: HUIPatternLockView, count: Int, password: String?) -> Void in
            guard count > 0 else {
                return
            }
            
            let normalImage = UIImage(named: "gesture_dot_nor")
            let selectImage = UIImage(named: "gesture_dot_sel")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1 * Double(NSEC_PER_SEC)), execute: { 
                lockView.resetDotsState()
                lockView.normalDotImage = normalImage
                lockView.highlightedDotImage = selectImage
                
                let correctPassword = PCSDataManager.defaultManager().accountManager.user?.gesturePassword
                completion(password == correctPassword)
            })
        }
    }
    
    func drawNewGesture(_ completion: @escaping (String) -> Void) {
        promptLabel.text = "请绘制新的解锁图案"
        lockView.didDrawPatternWithPassword = {(lockView: HUIPatternLockView, count: Int, password: String?) -> Void in
            guard count > 0 else {
                return
            }
            
            let normalImage = UIImage(named: "gesture_dot_nor")
            let selectImage = UIImage(named: "gesture_dot_sel")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1 * Double(NSEC_PER_SEC)), execute: {
                lockView.resetDotsState()
                lockView.normalDotImage = normalImage
                lockView.highlightedDotImage = selectImage
                
                completion(password!)
            })
        }
    }
    
    func verfyNewGesture(_ lastPassword: String, completion:@escaping (Bool, String) -> Void) {
        promptLabel.text = "请再一次绘制解锁图案"
        lockView.didDrawPatternWithPassword = {(lockView: HUIPatternLockView, count: Int, password: String?) -> Void in
            guard count > 0 else {
                return
            }
            
            let normalImage = UIImage(named: "gesture_dot_nor")
            let selectImage = UIImage(named: "gesture_dot_sel")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(1 * Double(NSEC_PER_SEC)), execute: { 
                lockView.resetDotsState()
                lockView.normalDotImage = normalImage
                lockView.highlightedDotImage = selectImage
                
                if password == lastPassword {
                    let context = CoreDataManager.defalutManager().childContext()
                    context.perform({ () -> Void in
                        let manager = PCSDataManager.defaultManager().accountManager
                        manager.user?.gesturePassword = password
                        manager.user?.isDefault = true
                        
                        do {
                            try context.save()
                            CoreDataManager.defalutManager().saveContext({ () -> Void in
                                DispatchQueue.main.async(execute: { () -> Void in
                                    completion(true, "修改成功")
                                })
                            })
                        }
                        catch {
                            DispatchQueue.main.async(execute: { () -> Void in
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
