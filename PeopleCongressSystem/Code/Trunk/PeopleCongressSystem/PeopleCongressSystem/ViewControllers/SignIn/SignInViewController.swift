//
//  SignInViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

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
        
        self.accountTextField.leftViewMode = UITextFieldViewMode.Always
        self.passwordTextField.leftViewMode = UITextFieldViewMode.Always
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickServerSelect(sender: AnyObject) {
    }
    
    @IBAction func clickSignIn(sender: AnyObject) {
    }
    
    @IBAction func clickGesture(sender: AnyObject) {
    }
    
    @IBAction func clickFindPassword(sender: AnyObject) {
    }
    
    @IBAction func clickRemember(sender: AnyObject) {
    }
    
    @IBAction func clickAutoSignIn(sender: AnyObject) {
    }

    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
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
