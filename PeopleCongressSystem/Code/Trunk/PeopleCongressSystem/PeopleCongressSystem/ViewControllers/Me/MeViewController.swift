//
//  MeViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/7.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

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
                "消息推送设置",
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
        
        PCSCustomUtil.customNavigationController(self)
        
        CustomObjectUtil.customObjectsLayout([quitButton], backgroundColor: GlobalUtil.colorRGBA(230, g: 27, b: 39, a: 1.0), borderWidth: 0, borderColor: UIColor.clearColor(), corner: 3.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func clickQuit(sender: AnyObject) {
    }

    @IBAction func clickEdit(sender: AnyObject) {
        // TODO: 编辑
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

        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        let row = Rows(rawValue: indexPath.row)!
        cell.textLabel?.text = row.title()
        cell.textLabel?.textColor = GlobalUtil.colorRGBA(59, g: 59, b: 59, a: 1)
        cell.textLabel?.font = UIFont.systemFontOfSize(15)

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
