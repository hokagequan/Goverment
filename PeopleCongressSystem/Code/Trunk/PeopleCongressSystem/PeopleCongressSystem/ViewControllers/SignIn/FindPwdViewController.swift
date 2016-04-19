//
//  FindPwdViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class FindPwdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VerifyCodeDelegate {
    
    class UserInfo: NSObject {
        var mobile: String = ""
        var smsCode: String = ""
        var graphicCode: String = ""
    }
    
    enum Rows: Int {
        case Mobile = 0
        case VerifyCode
        case SMSCode
        case Max
        
        func title() -> String {
            let titles = ["请输入手机号码",
                "请输入图形码",
                "请输入短信验证码",
                ""]
            
            return titles[self.rawValue]
        }
        
        func icon() -> String {
            let icons = ["phone", "graphic_code", "sms_code", ""]
            
            return icons[self.rawValue]
        }
    }

    @IBOutlet weak var inputTableView: UITableView!
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        PCSCustomUtil.customNavigationController(self)
        
        CustomObjectUtil.customObjectsLayout([submitButton], backgroundColor: colorRed, borderWidth: 0, borderColor: nil, corner: 5.0)
//        inputTableView.registerNib(UINib(nibName: "VerifyCodeCell", bundle: nil), forCellReuseIdentifier: "VerifyCodeCell")
        inputTableView.layoutMargins = UIEdgeInsetsZero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isInfoValiable(row: Rows) -> String? {
        var repString: String? = nil
        
        switch row {
        case .Mobile:
            let cell = inputTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row.rawValue, inSection: 0)) as! VerifyCodeCell
            if cell.titleTextField.text == nil {
                self.showAlert("请输入手机号码")
                
                return nil
            }
            
            repString = cell.titleTextField.text
            
            break
        case .VerifyCode:
            let cell = inputTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row.rawValue, inSection: 0)) as! LocalVerifyCell
            if cell.titleTextField.text == nil {
                self.showAlert("请输入图形码")
                
                return nil
            }
            else if cell.titleTextField.text?.lowercaseString != cell.code.lowercaseString {
                self.showAlert("请输入正确的图形码")
                
                return nil
            }
            
            repString = cell.titleTextField.text
            
            break
        case .SMSCode:
            let cell = inputTableView.cellForRowAtIndexPath(NSIndexPath(forRow: row.rawValue, inSection: 0)) as! VerifyCodeCell
            if cell.titleTextField.text == nil {
                self.showAlert("请输入短信验证码")
                
                return nil
            }
            
            repString = cell.titleTextField.text
            
            break
        default:
            break
        }
        
        return repString
    }
    
    // MARK: - Actions
    
    @IBAction func clickSubmit(sender: AnyObject) {
        let userInfo = UserInfo()
        
        guard let mobile = self.isInfoValiable(Rows.Mobile) else {
            return
        }
        
        userInfo.mobile = mobile
        
        guard let graphicCode = self.isInfoValiable(Rows.VerifyCode) else {
            return
        }
        
        userInfo.graphicCode = graphicCode
        
        guard let smsCode = self.isInfoValiable(Rows.SMSCode) else {
            return
        }
        
        userInfo.smsCode = smsCode
        
        EZLoadingActivity.show("", disableUI: true)
        let req = VerifySMSReq()
        req.mobile = userInfo.mobile
        req.smsCode = userInfo.smsCode
        req.requestSimpleCompletion { (userInfo) in
            EZLoadingActivity.hide()
            
            if userInfo == nil {
                self.showAlert("验证码错误")
                
                return
            }
            
            PCSDataManager.defaultManager().accountManager.user = userInfo
            self.performSegueWithIdentifier("ChangePwdSegue", sender: userInfo)
        }
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - VerifyCodeDelegate
    
    func didClickDetail(cell: VerifyCodeCell) {
        guard let mobile = self.isInfoValiable(Rows.Mobile) else {
            return
        }
        
        guard let _ = self.isInfoValiable(Rows.VerifyCode) else {
            return
        }
        
        let req = GetSMSReq()
        req.mobile = mobile
        req.requestSimpleCompletion { (message) in
            self.showAlert(message)
            
            PCSDataManager.defaultManager().fireCountingDownGetSMS({ (count) in
                if count == 0 {
                    cell.detailButton.userInteractionEnabled = true
                    cell.detailButton.setTitle("获取短信验证码", forState: UIControlState.Normal)
                    
                    return
                }
                
                cell.detailButton.userInteractionEnabled = false
                cell.detailButton.setTitle("\(count)秒后重新获取", forState: UIControlState.Normal)
            })
        }
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.Max.rawValue
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = Rows(rawValue: indexPath.row)!
        
        if row == Rows.VerifyCode {
            let cell = tableView.dequeueReusableCellWithIdentifier("LocalVerifyCell", forIndexPath: indexPath) as! LocalVerifyCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.layoutMargins = UIEdgeInsetsZero
            
            cell.titleTextField.placeholder = row.title()
            cell.iconImageView.image = UIImage(named: row.icon())
            
            CustomObjectUtil.customObjectsLayout([cell.verifyCodeView], backgroundColor: UIColor.lightGrayColor(), borderWidth: 1.0, borderColor: UIColor.grayColor(), corner: 0)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VerifyCodeCell", forIndexPath: indexPath) as! VerifyCodeCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsetsZero
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.delegate = self
        
        cell.titleTextField.placeholder = row.title()
        cell.iconImageView.image = UIImage(named: row.icon())
        
        if row == Rows.SMSCode {
            cell.borderView.hidden = true
            cell.detailButton.hidden = true
        }
        else if row == Rows.Mobile {
            PCSDataManager.defaultManager().getSMSBlock = { (count) -> Void in
                if count == 0 {
                    cell.detailButton.userInteractionEnabled = true
                    cell.detailButton.setTitle("获取短信验证码", forState: UIControlState.Normal)
                    
                    return
                }
                
                cell.detailButton.userInteractionEnabled = false
                cell.detailButton.setTitle("\(count)秒后重新获取", forState: UIControlState.Normal)
            }
        }
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ChangePwdSegue" {
            let viewController = segue.destinationViewController as! ChangePasswordViewController
            viewController.isForgetReset = true
            
            let userInfo = sender as! UserEntity
            viewController.mobile = userInfo.tel!
        }
    }

}
