//
//  MeViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/7.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import DKImagePickerController
import EZLoadingActivity

class MeViewController: UITableViewController {
    
    enum Rows: Int {
        case Push = 0
        case BlackList
        case QRCodeDownload
        case ChangePassword
        case ChangeGesture
//        case Update
        case Help
        case Feedback
        case About
        case CA
        case Max
        
        func title() -> String {
            let titles = [
                "消息推送免打扰",
                "黑名单",
                "下载二维码",
                "修改登陆密码",
                "修改手势密码",
//                "版本升级",
                "在线帮助",
                "意见反馈",
                "关于",
                "CA认证",
                ""]
            
            return titles[self.rawValue]
        }
    }

    @IBOutlet var footerView: UIView!
    @IBOutlet weak var quitButton: UIButton!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameWidthLC: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        CustomObjectUtil.customObjectsLayout([quitButton], backgroundColor: GlobalUtil.colorRGBA(230, g: 27, b: 39, a: 1.0), borderWidth: 0, borderColor: UIColor.clearColor(), corner: 3.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadUserInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadUserInfo() {
        guard let user = UserProfileManager.sharedInstance().getCurUserProfile() else {
            return
        }
        
        // 名字
        nameLabel.text = user.username
        
        // 图片
        photoImageView.imageWithUsername(user.username, placeholderImage: nil)
        
        // 通知选项
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            EMClient.sharedClient().getPushOptionsFromServerWithError(nil)
            let indexPath = NSIndexPath(forRow: Rows.Push.rawValue, inSection: 0)
            self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func clickQuit(sender: AnyObject) {
        EMClient.sharedClient().logout(true)
    }

    @IBAction func clickEdit(sender: AnyObject) {
        // TODO: 编辑
        let alert = UIAlertController(title: nil, message: "更改昵称", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default) { (action) in
            guard let textField = alert.textFields?.first else {
                return
            }
            
            if textField.text == nil || textField.text?.characters.count == 0 {
                return
            }
            
            EZLoadingActivity.show("", disableUI: true)
            EMClient.sharedClient().setApnsNickname(textField.text)
            UserProfileManager.sharedInstance().updateUserProfileInBackground([kPARSE_HXUSER_NICKNAME: textField.text!], completion: { (success, error) in
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
        
        alert.addTextFieldWithConfigurationHandler(nil)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func clickEditPhoto(sender: AnyObject) {
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        let picker = DKImagePickerController()
        picker.maxSelectableCount = 1
        picker.assetType = DKImagePickerControllerAssetType.AllPhotos
        picker.didSelectAssets = {(assets: [DKAsset]) in
            EZLoadingActivity.show("", disableUI: true)
            for asset in assets {
                asset.fetchFullScreenImageWithCompleteBlock({ (image, info) -> Void in
                    if image == nil {
                        return
                    }
                    
                    UserProfileManager.sharedInstance().uploadUserHeadImageProfileInBackground(image, completion: { (success, error) in
                        EZLoadingActivity.hide()
                        if success == true {
                            let user = UserProfileManager.sharedInstance().getCurUserProfile()
                            self.photoImageView.imageWithUsername(user.username, placeholderImage: image)
                        }
                        else {
                            self.showAlert("保存失败")
                        }
                    })
                })
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        picker.didCancel = { () in
            picker.dismissViewControllerAnimated(true, completion: nil)
        }
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.Max.rawValue
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        let row = Rows(rawValue: indexPath.row)!
        cell.textLabel?.text = row.title()
        cell.textLabel?.textColor = GlobalUtil.colorRGBA(59, g: 59, b: 59, a: 1)
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        
        cell.detailTextLabel?.textColor = cell.textLabel?.textColor
        cell.detailTextLabel?.font = cell.textLabel?.font
        
        switch row {
        case .Push:
            let option = EMClient.sharedClient().pushOptions
            var detail = option.noDisturbStatus == EMPushNoDisturbStatusDay ? "开启" : "关闭"
            if option.noDisturbStatus == EMPushNoDisturbStatusCustom {
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = Rows(rawValue: indexPath.row)!
        switch row {
        case .QRCodeDownload:
            self.performSegueWithIdentifier("QRDownloadSegue", sender: nil)
            break
        case .ChangePassword:
            self.performSegueWithIdentifier("ChangePwdSegue", sender: self)
            break
        case .ChangeGesture:
            self.performSegueWithIdentifier("ChangeGestureSegue", sender: self)
            break
        case .Feedback:
            self.performSegueWithIdentifier("FeedbackSegue", sender: self)
            break
        case .About:
            self.performSegueWithIdentifier("AboutSegue", sender: self)
            break
        case .Help:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(PCSDataManager.defaultManager().content.helpURL)
            vc.naviTitle = row.title()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case .CA:
            self.performSegueWithIdentifier("CASegue", sender: self)
            break
        case .Push:
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            let onAction = UIAlertAction(title: "开启", style: UIAlertActionStyle.Default, handler: { (action) in
                let option = EMClient.sharedClient().pushOptions
                option.noDisturbStatus = EMPushNoDisturbStatusDay
                option.noDisturbingStartH = 0
                option.noDisturbingEndH = 24
                self.loadUserInfo()
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                    EMClient.sharedClient().updatePushOptionsToServer()
                })
            })
            
            let customAction = UIAlertAction(title: "只在夜间开启（22:00 － 7:00）", style: UIAlertActionStyle.Default, handler: { (action) in
                let option = EMClient.sharedClient().pushOptions
                option.noDisturbStatus = EMPushNoDisturbStatusCustom
                option.noDisturbingStartH = 22
                option.noDisturbingEndH = 7
                self.loadUserInfo()
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    EMClient.sharedClient().updatePushOptionsToServer()
                })
            })
            
            let offAction = UIAlertAction(title: "关闭", style: UIAlertActionStyle.Default, handler: { (action) in
                let option = EMClient.sharedClient().pushOptions
                option.noDisturbStatus = EMPushNoDisturbStatusClose
                option.noDisturbingStartH = -1
                option.noDisturbingEndH = -1
                self.loadUserInfo()
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    EMClient.sharedClient().updatePushOptionsToServer()
                })
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (action) in
                
            })
            
            alert.addAction(onAction)
            alert.addAction(customAction)
            alert.addAction(offAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            break
        default:
            break
        }
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
