//
//  FindPwdViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class FindPwdViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum Rows: Int {
        case Name = 0
        case Organization
        case Tel
        case Remark
        case Max
        
        func title() -> String {
            let titles = ["代表姓名:", "代表团:", "电话号码:", "完整输入:", ""]
            
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
        inputTableView.registerNib(UINib(nibName: "NormalImageTableCell", bundle: nil), forCellReuseIdentifier: "NormalImageTableCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickSubmit(sender: AnyObject) {
        let req = ResetPasswordReq()
        
        for i in 0..<Rows.Max.rawValue {
            let cell = inputTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! NormalImageTableCell
            let row = Rows(rawValue: i)!
            
            switch row {
            case .Name:
                if cell.titleTextField.text == nil {
                    self.showAlert("请输入名字")
                    
                    return
                }
                req.name = cell.titleTextField.text
                
                break
            case .Tel:
                if cell.titleTextField.text == nil {
                    self.showAlert("请输入电话号码")
                    
                    return
                }
                req.tel = cell.titleTextField.text
                
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
            
            self.showAlert(result.value!)
        }
    }
    
    @IBAction func hideKeyboard(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.Max.rawValue
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NormalImageTableCell", forIndexPath: indexPath) as! NormalImageTableCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        let row = Rows(rawValue: indexPath.row)!
        cell.headerText = row.title()
        cell.border.hidden = true
        cell.iconWidthLC.constant = 0
        
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
