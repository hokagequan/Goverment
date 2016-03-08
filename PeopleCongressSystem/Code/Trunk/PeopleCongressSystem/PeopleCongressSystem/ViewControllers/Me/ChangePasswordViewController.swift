//
//  ChangePasswordViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/8.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var theOldPwdTextField: UITextField!
    @IBOutlet weak var theNewPwdTextField: UITextField!
    @IBOutlet weak var theVerifyPwdTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        CustomObjectUtil.customObjectsLayout([saveButton], backgroundColor: colorRed, borderWidth: 0.0, borderColor: nil, corner: 5.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickSave(sender: AnyObject) {
        if theOldPwdTextField.text == nil {
            self.showAlert("请输入旧密码")
            
            return
        }
        
        if theNewPwdTextField.text == nil {
            self.showAlert("请输入新密码")
            
            return
        }
        
        if theVerifyPwdTextField.text == nil {
            self.showAlert("请重新输入一次新密码")
            
            return
        }
        
        if theNewPwdTextField.text != theVerifyPwdTextField.text {
            self.showAlert("两次密码输入不一致")
            
            return
        }
        
        PCSDataManager.defaultManager().accountManager.changePassword(theOldPwdTextField.text!, theNew: theNewPwdTextField!.text) { (success, message) -> Void in
            if success == true {
                self.showAlert("保存成功")
            }
            else {
                self.showAlert(message!)
            }
        }
        
    }
    
    // MARK: - UITextField
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
