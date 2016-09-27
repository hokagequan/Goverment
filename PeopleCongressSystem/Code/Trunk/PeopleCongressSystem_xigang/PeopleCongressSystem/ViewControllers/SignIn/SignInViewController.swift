//
//  SignInViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

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
        self.navigationController?.navigationBar.isTranslucent = false
        
        CustomObjectUtil.customObjectsLayout([accountTextField, passwordTextField, serverSelectButton], backgroundColor: UIColor.white, borderWidth: 0.0, borderColor: nil, corner: 3.0)
        CustomObjectUtil.customObjectsLayout([signInButton], backgroundColor: UIColor.clear, borderWidth: 1.0, borderColor: UIColor.white, corner: 3.0)
        
        accountTextField.leftViewMode = UITextFieldViewMode.always
        accountTextField.leftView = phoneView
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        passwordTextField.leftView = passwordView
        
        for topLC in topSpaceLCs {
            topLC.constant = topLC.constant * GlobalUtil.rateForHeight()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if let isRemember = SettingsManager.getData(SettingKey.RememberPassword.rawValue) as? Bool {
            rememberButton.isSelected = isRemember
            
            if rememberButton.isSelected == true {
                accountTextField.text = PCSDataManager.defaultManager().accountManager.user?.account
                passwordTextField.text = PCSDataManager.defaultManager().accountManager.user?.password
            }
        }
        
        if let isAuto = SettingsManager.getData(SettingKey.AutoSignIn.rawValue) as? Bool {
            autoButton.isSelected = isAuto
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let isAuto = SettingsManager.getData(SettingKey.AutoSignIn.rawValue) as? Bool {
            if (isAuto == true && PCSDataManager.defaultManager().isLaunch == true) {
                accountTextField.text = PCSDataManager.defaultManager().accountManager.user?.account
                passwordTextField.text = PCSDataManager.defaultManager().accountManager.user?.password
                self.clickSignIn(signInButton)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view.endEditing(true)
        accountTextField.text = nil
        passwordTextField.text = nil
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickServerSelect(_ sender: AnyObject) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "http://175.170.128.160:8099", "")
        actionSheet.show(in: self.view)
    }
    
    @IBAction func clickSignIn(_ sender: AnyObject) {
        if accountTextField.text == "" || passwordTextField.text == "" {
            self.showAlert("请输入用户名或手机号")
            
            return
        }
        
        EZLoadingActivity.show("", disableUI: true)
        
        PCSDataManager.defaultManager().appAvaliable { (valid, errMsg) in
            if valid == false {
                EZLoadingActivity.hide()
                self.showAlert(errMsg ?? "请稍后再试")
                
                return
            }
            
            PCSDataManager.defaultManager().accountManager.signIn(self.accountTextField.text!, password: self.passwordTextField.text!) { (success, errorMessage, errorCode) -> Void in
                EZLoadingActivity.hide()
                
                if success == true {
                    SettingsManager.saveData(self.rememberButton.isSelected as AnyObject, key: SettingKey.RememberPassword.rawValue)
                    SettingsManager.saveData(self.autoButton.isSelected as AnyObject, key: SettingKey.AutoSignIn.rawValue)
                    self.performSegue(withIdentifier: "MainSegue", sender: self)
                }
                else {
                    self.showAlert(errorMessage!)
                }
            }
        }
    }
    
    @IBAction func clickRemember(_ sender: AnyObject) {
        rememberButton.isSelected = !rememberButton.isSelected
    }
    
    @IBAction func clickAutoSignIn(_ sender: AnyObject) {
        autoButton.isSelected = !autoButton.isSelected
    }
    
    @IBAction func clickGesture(_ sender: AnyObject) {
        if PCSDataManager.defaultManager().accountManager.user?.gesturePassword == nil {
            self.showAlert("请设置后进行手势密码登录")
            
            return
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.performSegue(withIdentifier: "GestureSegue", sender: self)
    }
    
    @IBAction func clickFindPassword(_ sender: AnyObject) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.performSegue(withIdentifier: "FindPasswordSegue", sender: self)
    }

    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - UIActionSheet
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            return
        }
        
        if let serverString = actionSheet.buttonTitle(at: buttonIndex) {
            SettingsManager.saveData(serverString as AnyObject, key: SettingKey.Server.rawValue)
        }
    }
    
    // MARK: - UITextField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToSignIn(_ segue: UIStoryboardSegue) {
        SettingsManager.saveData(false as AnyObject, key: SettingKey.AutoSignIn.rawValue)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GestureSegue" {
        }
        else if segue.identifier == "FindPasswordSegue" {
        }
    }

}
