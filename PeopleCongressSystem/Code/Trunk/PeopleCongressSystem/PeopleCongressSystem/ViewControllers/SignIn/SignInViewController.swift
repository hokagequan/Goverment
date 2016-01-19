//
//  SignInViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UIActionSheetDelegate, UITextFieldDelegate {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serverSelectButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var gestureButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBOutlet weak var rememberButton: UIButton!
    @IBOutlet weak var autoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        CustomObjectUtil.customObjectsLayout([accountTextField, passwordTextField, serverSelectButton], backgroundColor: UIColor.whiteColor(), borderWidth: 0.0, borderColor: nil, corner: 3.0)
        CustomObjectUtil.customObjectsLayout([signInButton], backgroundColor: UIColor.clearColor(), borderWidth: 1.0, borderColor: UIColor.whiteColor(), corner: 3.0)
        
        accountTextField.leftViewMode = UITextFieldViewMode.Always
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        
        if let isRemember = SettingsManager.getData(SettingKey.RememberPassword.rawValue) as? Bool {
            // TODO: 设置默认用户
            rememberButton.selected = isRemember
        }
        
        if let isAuto = SettingsManager.getData(SettingKey.AutoSignIn.rawValue) as? Bool {
            autoButton.selected = isAuto
        }
        
        gestureButton.hidden = SettingsManager.getData(SettingKey.GesturePassword.rawValue) == nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickServerSelect(sender: AnyObject) {
        // TODO: 服务器选择
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "", "")
        actionSheet.showInView(self.view)
    }
    
    @IBAction func clickSignIn(sender: AnyObject) {
        if accountTextField.text == "" {
            self.showAlert("请输入手机号")
            
            return
        }
        
        if passwordTextField.text == "" {
            self.showAlert("请输入密码")
            
            return
        }
        
        // TODO: 登录; 登录成功设置状态; 登录成功存入数据库
        SettingsManager.saveData(rememberButton.selected, key: SettingKey.RememberPassword.rawValue)
        SettingsManager.saveData(autoButton.selected, key: SettingKey.AutoSignIn.rawValue)
        self.performSegueWithIdentifier("MainSegue", sender: self)
    }
    
    @IBAction func clickRemember(sender: AnyObject) {
        rememberButton.selected = !rememberButton.selected
    }
    
    @IBAction func clickAutoSignIn(sender: AnyObject) {
        autoButton.selected = !autoButton.selected
    }

    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - UIActionSheet
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        
        if let serverString = actionSheet.buttonTitleAtIndex(buttonIndex) {
            SettingsManager.saveData(serverString, key: SettingKey.Server.rawValue)
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
