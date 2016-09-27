//
//  MeViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/7.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity
import DKImagePickerController

class MeViewController: UITableViewController {
    
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var quitButton: UIButton!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameWidthLC: NSLayoutConstraint!
    
    var listItems = [Dictionary<String, String>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        CustomObjectUtil.customObjectsLayout([quitButton], backgroundColor: GlobalUtil.colorRGBA(230, g: 27, b: 39, a: 1.0), borderWidth: 0, borderColor: UIColor.clear, corner: 3.0)
        
        self.loadListItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserInfo() {
//        guard let user = UserProfileManager.sharedInstance().getCurUserProfile() else {
//            return
//        }
        
        // 名字
//        nameLabel.text = user.username ?? user.nickname
        nameLabel.text = PCSDataManager.defaultManager().accountManager.user?.name
        
        // 图片
//        photoImageView.imageWithUsername(user.username, placeholderImage: nil)
        if PCSDataManager.defaultManager().accountManager.user?.photoName == nil || photoImageView.image == nil {
            EZLoadingActivity.show("", disableUI: true)
            PCSDataManager.defaultManager().accountManager.getInfo { (success, message, errorCode) -> Void in
                EZLoadingActivity.hide()
                if success == true {
                    if let photoName = PCSDataManager.defaultManager().accountManager.user!.photoName {
                        let photoURL = "\(photoDownloadURL)\(photoName)"
                        self.photoImageView.loadImageURL(photoURL, name: photoName, placeholder: "")
                    }
                }
                else {
                    ResponseErrorManger.defaultManager().handleError(errorCode, message: message)
                }
            }
        }
        
        // 通知选项
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            EMClient.shared().getPushOptionsFromServerWithError(nil)
            
            var index = -1
            for i in 0..<self.listItems.count {
                let dict = self.listItems[i]
                if dict["title"] == "消息推送免打扰" {
                    index = i
                    break
                }
            }
            
            if index == -1 {
                return
            }
            
            let indexPath = IndexPath(row: index, section: 0)
            DispatchQueue.main.async(execute: { 
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            })
        }
    }
    
    func loadListItems() {
        listItems = [
            ["title": "消息推送免打扰", "method": "clickPush"],
            ["title": "黑名单", "method": "clickBlackList"],
            ["title": "下载二维码", "method": "clickQRCodeDownload"],
            ["title": "修改登陆密码", "method": "clickChangePassword"],
            ["title": "修改手势密码", "method": "clickChangeGesture"],
            ["title": "在线帮助", "method": "clickHelp"],
            ["title": "意见反馈", "method": "clickFeedback"],
            ["title": "关于", "method": "clickAbout"],
            ["title": "CA认证", "method": "clickCA"]
        ]
        
        if PCSDataManager.defaultManager().content is CongressContentInfo {
            listItems.insert(["title": "扫一扫签到", "method": "clickCheckIn"], at: 0)
            listItems.insert(["title": "名片", "method": "clickBusinessCard"], at: 0)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func clickQuit(_ sender: AnyObject) {
        EMClient.shared().logout(true)
    }

    @IBAction func clickEdit(_ sender: AnyObject) {
        // 更改昵称，暂时屏蔽
        return
        
        let alert = UIAlertController(title: nil, message: "更改昵称", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default) { (action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            
            if textField.text == nil || textField.text?.characters.count == 0 {
                return
            }
            
            EZLoadingActivity.show("", disableUI: true)
            EMClient.shared().setApnsNickname(textField.text)
            UserProfileManager.sharedInstance().updateUserProfile(inBackground: [kPARSE_HXUSER_NICKNAME: textField.text!], completion: { (success, error) in
                EZLoadingActivity.hide()
                
                if success == true {
                    self.nameLabel.text = textField.text
                }
                else {
                    self.showAlert("保存失败")
                }
            })
        }
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        alert.addTextField(configurationHandler: nil)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickEditPhoto(_ sender: AnyObject) {
        // 更改头像，暂时屏蔽
        return
            
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let picker = DKImagePickerController()
        picker.maxSelectableCount = 1
        picker.assetType = DKImagePickerControllerAssetType.allPhotos
        picker.didSelectAssets = {(assets: [DKAsset]) in
            EZLoadingActivity.show("", disableUI: true)
            for asset in assets {
                asset.fetchFullScreenImageWithCompleteBlock({ (image, info) -> Void in
                    if image == nil {
                        return
                    }
                    
                    UserProfileManager.sharedInstance().uploadUserHeadImageProfile(inBackground: image, completion: { (success, error) in
                        EZLoadingActivity.hide()
                        if success == true {
                            let user = UserProfileManager.sharedInstance().getCurUserProfile()!
                            self.photoImageView.image(withUsername: user.username, placeholderImage: image)
                        }
                        else {
                            self.showAlert("保存失败")
                        }
                    })
                })
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        
        picker.didCancel = { () in
            picker.dismiss(animated: true, completion: nil)
        }
        
        self.present(picker, animated: true, completion: nil)
    }
    
    func clickQRCodeDownload() {
        self.performSegue(withIdentifier: "QRDownloadSegue", sender: nil)
    }
    
    func clickPush() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let onAction = UIAlertAction(title: "开启", style: UIAlertActionStyle.default, handler: { (action) in
            let option = EMClient.shared().pushOptions
            option?.noDisturbStatus = EMPushNoDisturbStatusDay
            option?.noDisturbingStartH = 0
            option?.noDisturbingEndH = 24
            self.loadUserInfo()
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                EMClient.shared().updatePushOptionsToServer()
            })
        })
        
        let customAction = UIAlertAction(title: "只在夜间开启（22:00 － 7:00）", style: UIAlertActionStyle.default, handler: { (action) in
            let option = EMClient.shared().pushOptions
            option?.noDisturbStatus = EMPushNoDisturbStatusCustom
            option?.noDisturbingStartH = 22
            option?.noDisturbingEndH = 7
            self.loadUserInfo()
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                EMClient.shared().updatePushOptionsToServer()
            })
        })
        
        let offAction = UIAlertAction(title: "关闭", style: UIAlertActionStyle.default, handler: { (action) in
            let option = EMClient.shared().pushOptions
            option?.noDisturbStatus = EMPushNoDisturbStatusClose
            option?.noDisturbingStartH = -1
            option?.noDisturbingEndH = -1
            self.loadUserInfo()
            
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
                EMClient.shared().updatePushOptionsToServer()
            })
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: { (action) in
            
        })
        
        alert.addAction(onAction)
        alert.addAction(customAction)
        alert.addAction(offAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func clickBlackList() {
        let blackListViewController = BlackListViewController(nibName: nil, bundle: nil)
        blackListViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(blackListViewController, animated: true)
    }
    
    func clickChangePassword() {
        self.performSegue(withIdentifier: "ChangePwdSegue", sender: self)
    }
    
    func clickChangeGesture() {
        self.performSegue(withIdentifier: "ChangeGestureSegue", sender: self)
    }
    
    func clickHelp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
        vc.URL = PCSDataManager.defaultManager().htmlURL(PCSDataManager.defaultManager().content.helpURL)
        vc.naviTitle = "在线帮助"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clickFeedback() {
        self.performSegue(withIdentifier: "FeedbackSegue", sender: self)
    }
    
    func clickAbout() {
        self.performSegue(withIdentifier: "AboutSegue", sender: self)
    }
    
    func clickCA() {
        self.performSegue(withIdentifier: "CASegue", sender: self)
    }
    
    func clickBusinessCard() {
        self.performSegue(withIdentifier: "BusinessCardSegue", sender: self)
    }
    
    func clickCheckIn() {
        let storyboard = UIStoryboard(name: "CheckIn", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "QRCodeScanViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        let dict = listItems[(indexPath as NSIndexPath).row]
        let title = dict["title"]!
        
        cell.textLabel?.text = title
        cell.textLabel?.textColor = GlobalUtil.colorRGBA(59, g: 59, b: 59, a: 1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        cell.detailTextLabel?.textColor = cell.textLabel?.textColor
        cell.detailTextLabel?.font = cell.textLabel?.font
        
        switch title {
        case "消息推送免打扰":
            let option = EMClient.shared().pushOptions
            var detail = option?.noDisturbStatus == EMPushNoDisturbStatusDay ? "开启" : "关闭"
            if option?.noDisturbStatus == EMPushNoDisturbStatusCustom {
                detail = "只在夜间开启（22:00 － 7:00）"
            }
            cell.detailTextLabel?.text = detail
            
            break
        default:
            cell.detailTextLabel?.text = nil
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = listItems[(indexPath as NSIndexPath).row]
        self.perform(Selector(dict["method"]!), with: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
