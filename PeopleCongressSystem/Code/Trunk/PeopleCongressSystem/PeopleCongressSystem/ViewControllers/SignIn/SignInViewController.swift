//
//  SignInViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

let account = "ios"
let password = "a"

// Worker
//let account = "admin"
//let password = "a"


class SignInViewController: UIViewController, UIActionSheetDelegate, UITextFieldDelegate {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serverSelectButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var gestureButton: UIButton!
    @IBOutlet weak var findPasswordButton: UIButton!
    @IBOutlet weak var rememberButton: UIButton!
    @IBOutlet weak var autoButton: UIButton!
    @IBOutlet var phoneView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var serverView: UIView!
    @IBOutlet var topSpaceLCs: [NSLayoutConstraint]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        CustomObjectUtil.customObjectsLayout([accountTextField, passwordTextField, serverSelectButton], backgroundColor: UIColor.whiteColor(), borderWidth: 0.0, borderColor: nil, corner: 3.0)
        CustomObjectUtil.customObjectsLayout([signInButton], backgroundColor: UIColor.clearColor(), borderWidth: 1.0, borderColor: UIColor.whiteColor(), corner: 3.0)
        
        accountTextField.leftViewMode = UITextFieldViewMode.Always
        accountTextField.leftView = phoneView
        passwordTextField.leftViewMode = UITextFieldViewMode.Always
        passwordTextField.leftView = passwordView
        
        for topLC in topSpaceLCs {
            topLC.constant = topLC.constant * GlobalUtil.rateForHeight()
        }
        
//        gestureButton.hidden = SettingsManager.getData(SettingKey.GesturePassword.rawValue) == nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        gestureButton.hidden = PCSDataManager.defaultManager().accountManager.user?.gesturePassword == nil
        
        if let isRemember = SettingsManager.getData(SettingKey.RememberPassword.rawValue) as? Bool {
            // TODO: 设置默认用户
            rememberButton.selected = isRemember
            
            if rememberButton.selected == true {
                accountTextField.text = PCSDataManager.defaultManager().accountManager.user?.account
                passwordTextField.text = PCSDataManager.defaultManager().accountManager.user?.password
            }
        }
        
        if let isAuto = SettingsManager.getData(SettingKey.AutoSignIn.rawValue) as? Bool {
            autoButton.selected = isAuto
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let isAuto = SettingsManager.getData(SettingKey.AutoSignIn.rawValue) as? Bool {
            if (isAuto == true && PCSDataManager.defaultManager().isLaunch == true) {
                accountTextField.text = PCSDataManager.defaultManager().accountManager.user?.account
                passwordTextField.text = PCSDataManager.defaultManager().accountManager.user?.password
                self.clickSignIn(signInButton)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        accountTextField.text = nil
        passwordTextField.text = nil
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickServerSelect(sender: AnyObject) {
        // TODO: 服务器选择
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "http://175.170.128.160:8099", "")
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
        
//        accountTextField.text = account
//        passwordTextField.text = password
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().accountManager.signIn(accountTextField.text!, password: passwordTextField.text!) { (success, errorMessage) -> Void in
            EZLoadingActivity.hide()
            
            if success == true {
                SettingsManager.saveData(self.rememberButton.selected, key: SettingKey.RememberPassword.rawValue)
                SettingsManager.saveData(self.autoButton.selected, key: SettingKey.AutoSignIn.rawValue)
                self.performSegueWithIdentifier("MainSegue", sender: self)
            }
            else {
                self.showAlert(errorMessage!)
            }
        }
    }
    
    @IBAction func clickRemember(sender: AnyObject) {
        rememberButton.selected = !rememberButton.selected
    }
    
    @IBAction func clickAutoSignIn(sender: AnyObject) {
        autoButton.selected = !autoButton.selected
    }
    
    @IBAction func clickGesture(sender: AnyObject) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.performSegueWithIdentifier("GestureSegue", sender: self)
    }
    
    @IBAction func clickFindPassword(sender: AnyObject) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.performSegueWithIdentifier("FindPasswordSegue", sender: self)
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
    
    // MARK: - Navigation
    
    @IBAction func unwindToSignIn(segue: UIStoryboardSegue) {
        
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GestureSegue" {
        }
        else if segue.identifier == "FindPasswordSegue" {
        }
    }

}
