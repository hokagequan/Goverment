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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.customLockView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func customLockView() {
        let defaultLineColor = HUIPatternLockView.defaultLineColor
        
        let normalImage = UIImage(named: "gesture_dot_nor")
        let selectImage = UIImage(named: "gesture_dot_sel")
        
        CustomObjectUtil.customObjectsLayout([lockView], backgroundColor: UIColor.whiteColor(), borderWidth: 1.0, borderColor: GlobalUtil.colorRGBA(240.0, g: 240.0, b: 240.0, a: 1.0), corner: 2.0)
        
        lockView.didDrawPatternWithPassword = {(lockView: HUIPatternLockView, count: Int, password: String?) -> Void in
            guard count > 0 else {
                return
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                lockView.resetDotsState()
                lockView.lineColor = defaultLineColor
                lockView.normalDotImage = normalImage
                lockView.highlightedDotImage = selectImage
                
                let context = CoreDataManager.defalutManager().childContext()
                context.performBlock({ () -> Void in
                    let manager = PCSDataManager.defaultManager().accountManager
                    manager.user?.gesturePassword = password
                    manager.user?.isDefault = true
                    
                    do {
                        try context.save()
                        CoreDataManager.defalutManager().saveContext({ () -> Void in
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.showAlert("修改成功")
                            })
                        })
                    }
                    catch {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.showAlert("修改失败")
                        })
                    }
                })
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
