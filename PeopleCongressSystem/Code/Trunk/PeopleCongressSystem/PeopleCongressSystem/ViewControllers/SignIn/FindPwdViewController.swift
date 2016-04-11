//
//  FindPwdViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class FindPwdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, VerifyCodeDelegate {
    
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
    
    // MARK: - Actions
    
    @IBAction func clickSubmit(sender: AnyObject) {
        let req = ResetPasswordReq()
        
        for i in 0..<Rows.Max.rawValue {
            let row = Rows(rawValue: i)!
            
            switch row {
            case .Mobile:
                let cell = inputTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! VerifyCodeCell
                if cell.titleTextField.text == nil {
                    self.showAlert("请输入手机号码")
                    
                    return
                }
                req.name = cell.titleTextField.text
                
                break
            case .VerifyCode:
                let cell = inputTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! LocalVerifyCell
                if cell.titleTextField.text == nil {
                    self.showAlert("请输入图形码")
                    
                    return
                }
                else if cell.titleTextField.text != cell.code {
                    self.showAlert("请输入正确的图形码")
                    
                    return
                }
                
                req.tel = cell.titleTextField.text
                
                break
            case .SMSCode:
                let cell = inputTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! VerifyCodeCell
                if cell.titleTextField.text == nil {
                    self.showAlert("请输入短信验证码")
                    
                    return
                }
                
                break
            default:
                break
            }
        }
        
        req.requestCompletion { (response) -> Void in
            guard let result = response?.result else {
                self.showAlert("提交失败")
                
                return
            }
            
            if (result.isFailure == true) {
                self.showAlert("提交失败")
                
                return
            }
            
            if result.value == nil {
                self.showAlert("提交失败")
                
                return
            }
            
            self.showAlert("客服会尽快与您联系，请保持手机畅通")
        }
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - VerifyCodeDelegate
    
    func didClickDetail(cell: VerifyCodeCell) {
        // TODO: 获取短信验证码
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
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("VerifyCodeCell", forIndexPath: indexPath) as! VerifyCodeCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsetsZero
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.delegate = self
        
        cell.titleTextField.placeholder = row.title()
        
        if row == Rows.SMSCode {
            cell.borderView.hidden = true
            cell.detailButton.hidden = true
        }
        
        return cell
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
