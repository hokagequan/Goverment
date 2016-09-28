//
//  UnCheckedInListViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/26.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class UnCheckedInListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var naviView: PCSNavigationView!
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet var notifySelectionView: UIControl!
    @IBOutlet weak var notifyContainerView: UIView!
    
    var activityID: Int = 0
    var personList: Array<Person>? = nil
    var selectedIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PCSCustomUtil.customNavigationController(self)
        
        self.layoutUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        EZLoadingActivity.show("", disableUI: true)
        let req = GetUnCheckInListReq()
        req.activityID = activityID
        req.requestSimpleCompletion { (success, persons, errorCode) in
            EZLoadingActivity.hide()
            
            if success == true {
                self.personList = persons
                self.listTableView.reloadData()
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: "未签到人员获取失败")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideNotifySelection() {
        selectedIndex = -1
        notifySelectionView.removeFromSuperview()
    }
    
    func layoutUI() {
        CustomObjectUtil.customObjectsLayout([notifyContainerView], backgroundColor: UIColor.white, borderWidth: 0, borderColor: nil, corner: 5.0)
    }
    
    func showNotifySelection(_ index: Int) {
        selectedIndex = index
        
        let window = UIApplication.shared.keyWindow!
        notifySelectionView.frame = window.bounds
        window.addSubview(notifySelectionView)
    }
    
    func sendNotify(_ type: SendType) {
        defer {
            self.hideNotifySelection()
        }
        
        if selectedIndex < 0 {
            return
        }
        
        EZLoadingActivity.show("", disableUI: true)
        let person = personList?[selectedIndex]
        let req = SendAPNSReq()
        req.congressID = person!.congressID!
        req.mobile = person!.mobile
        req.type = type
        req.requestSimpleCompletion { (success, errorCode) in
            EZLoadingActivity.hide()
            if success == false {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: "网络异常，请稍后再试")
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func clickAPNS(_ sender: AnyObject) {
        self.sendNotify(SendType.APNS)
    }
    
    @IBAction func clickSMS(_ sender: AnyObject) {
        self.sendNotify(SendType.SMS)
    }
    
    @IBAction func clickCall(_ sender: AnyObject) {
        defer {
            self.hideNotifySelection()
        }
        
        if selectedIndex < 0 {
            return
        }
        
        guard let mobile = personList?[selectedIndex].mobile else {
            return
        }
        
        guard let callURL = URL(string: "tel://\(mobile)") else {
            return
        }
        
        UIApplication.shared.openURL(callURL)
    }
    
    @IBAction func clickMessage(_ sender: AnyObject) {
        defer {
            self.hideNotifySelection()
        }
        
        if selectedIndex < 0 {
            return
        }
        
        guard let huanxin = personList?[selectedIndex].huanxin else {
            return
        }
        
        guard let chatViewController = ChatViewController(conversationChatter: huanxin, conversationType: EMConversationTypeChat) else {
            return
        }
        chatViewController.title = huanxin
        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    @IBAction func clickHideNotifySelection(_ sender: AnyObject) {
        self.hideNotifySelection()
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (personList != nil) ? personList!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnCheckedInCell", for: indexPath) as! UnCheckedInCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let person = personList?[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = person?.name
        cell.detailLabel.text = person?.organization
        cell.phoneLabel.text = person?.mobile
        
        cell.clickNotifyBlock = {(cell) -> Void in
            let index = (tableView.indexPath(for: cell) as NSIndexPath?)?.row
            self.showNotifySelection(index!)
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