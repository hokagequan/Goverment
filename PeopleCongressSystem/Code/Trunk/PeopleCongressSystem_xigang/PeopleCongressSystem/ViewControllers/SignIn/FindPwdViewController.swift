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
        case mobile = 0
        case verifyCode
        case smsCode
        case max
        
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
        inputTableView.layoutMargins = UIEdgeInsets.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isInfoValiable(_ row: Rows) -> String? {
        var repString: String? = nil
        
        switch row {
        case .mobile:
            let cell = inputTableView.cellForRow(at: IndexPath(row: row.rawValue, section: 0)) as! VerifyCodeCell
            if cell.titleTextField.text == nil {
                self.showAlert("请输入手机号码")
                
                return nil
            }
            
            repString = cell.titleTextField.text
            
            break
        case .verifyCode:
            let cell = inputTableView.cellForRow(at: IndexPath(row: row.rawValue, section: 0)) as! LocalVerifyCell
            if cell.titleTextField.text == nil {
                self.showAlert("请输入图形码")
                
                return nil
            }
            else if cell.titleTextField.text?.lowercased() != cell.code.lowercased() {
                self.showAlert("请输入正确的图形码")
                
                return nil
            }
            
            repString = cell.titleTextField.text
            
            break
        case .smsCode:
            let cell = inputTableView.cellForRow(at: IndexPath(row: row.rawValue, section: 0)) as! VerifyCodeCell
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
    
    @IBAction func clickSubmit(_ sender: AnyObject) {
        let userInfo = UserInfo()
        
        guard let mobile = self.isInfoValiable(Rows.mobile) else {
            return
        }
        
        userInfo.mobile = mobile
        
        guard let graphicCode = self.isInfoValiable(Rows.verifyCode) else {
            return
        }
        
        userInfo.graphicCode = graphicCode
        
        guard let smsCode = self.isInfoValiable(Rows.smsCode) else {
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
            self.performSegue(withIdentifier: "ChangePwdSegue", sender: userInfo)
        }
    }
    
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - VerifyCodeDelegate
    
    func didClickDetail(_ cell: VerifyCodeCell) {
        guard let mobile = self.isInfoValiable(Rows.mobile) else {
            return
        }
        
        guard let _ = self.isInfoValiable(Rows.verifyCode) else {
            return
        }
        
        let req = GetSMSReq()
        req.mobile = mobile
        req.requestSimpleCompletion { (message) in
            self.showAlert(message)
            
            PCSDataManager.defaultManager().fireCountingDownGetSMS({ (count) in
                if count == 0 {
                    cell.detailButton.isUserInteractionEnabled = true
                    cell.detailButton.setTitle("获取短信验证码", for: UIControlState())
                    
                    return
                }
                
                cell.detailButton.isUserInteractionEnabled = false
                cell.detailButton.setTitle("\(count)秒后重新获取", for: UIControlState())
            })
        }
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.max.rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = Rows(rawValue: (indexPath as NSIndexPath).row)!
        
        if row == Rows.verifyCode {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocalVerifyCell", for: indexPath) as! LocalVerifyCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.layoutMargins = UIEdgeInsets.zero
            
            cell.titleTextField.placeholder = row.title()
            cell.iconImageView.image = UIImage(named: row.icon())
            
            CustomObjectUtil.customObjectsLayout([cell.verifyCodeView], backgroundColor: UIColor.lightGray, borderWidth: 1.0, borderColor: UIColor.gray, corner: 0)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "VerifyCodeCell", for: indexPath) as! VerifyCodeCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsets.zero
        cell.accessoryType = UITableViewCellAccessoryType.none
        cell.delegate = self
        
        cell.titleTextField.placeholder = row.title()
        cell.iconImageView.image = UIImage(named: row.icon())
        
        if row == Rows.smsCode {
            cell.borderView.isHidden = true
            cell.detailButton.isHidden = true
        }
        else if row == Rows.mobile {
            PCSDataManager.defaultManager().getSMSBlock = { (count) -> Void in
                if count == 0 {
                    cell.detailButton.isUserInteractionEnabled = true
                    cell.detailButton.setTitle("获取短信验证码", for: UIControlState())
                    
                    return
                }
                
                cell.detailButton.isUserInteractionEnabled = false
                cell.detailButton.setTitle("\(count)秒后重新获取", for: UIControlState())
            }
        }
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ChangePwdSegue" {
            let viewController = segue.destination as! ChangePasswordViewController
            viewController.isForgetReset = true
            
            let userInfo = sender as! UserEntity
            viewController.mobile = userInfo.tel!
        }
    }

}
