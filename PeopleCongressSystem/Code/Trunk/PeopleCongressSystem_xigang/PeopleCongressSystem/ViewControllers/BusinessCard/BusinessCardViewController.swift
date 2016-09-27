//
//  BusinessCardViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class BusinessCardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    enum Rows: Int {
        case organization = 0
        case gender
        case tel
        case birthday
        case nation
        case job
        case max
        
        func title() -> String {
            let titles = ["代表团:", "性别:", "电话:", "生日:", "民族:", "职位:", ""]
            
            return titles[self.rawValue]
        }
        
        func key() -> String {
            let keys = ["organization", "gender", "tel", "birthday", "nation", "job", ""]
            
            return keys[self.rawValue]
        }
    }

    @IBOutlet var headerView: UIView!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet var infoTableView: UITableView!
    
    @IBOutlet var specialView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        infoTableView.layoutMargins = UIEdgeInsets.zero
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PCSDataManager.defaultManager().accountManager.user?.photoName == nil || photoImageView.image == nil {
            EZLoadingActivity.show("", disableUI: true)
            PCSDataManager.defaultManager().accountManager.getInfo { (success, message, errorCode) -> Void in
                EZLoadingActivity.hide()
                
                if success == true {
                    self.refreshInfo()
                }
                else {
                    ResponseErrorManger.defaultManager().handleError(errorCode, message: message)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshInfo() {
        if let photoName = PCSDataManager.defaultManager().accountManager.user!.photoName {
            let photoURL = "\(photoDownloadURL)\(photoName)"
            photoImageView.loadImageURL(photoURL, name: photoName, placeholder: "")
        }
        
        if let qrCode = PCSDataManager.defaultManager().accountManager.user!.qrCode {
            let qrCodeURL = "\(qrCodeDownloadURL)\(qrCode)"
            qrCodeImageView.loadImageURL(qrCodeURL, name: qrCode, placeholder: "")
        }
        
        nameLabel.text = PCSDataManager.defaultManager().accountManager.user?.name
        
        infoTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func clickScan(_ sender: AnyObject) {
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.max.rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsets.zero
        
        let row = Rows(rawValue: (indexPath as NSIndexPath).row)!
        cell.textLabel?.text = row.title()
        cell.detailTextLabel?.text = PCSDataManager.defaultManager().accountManager.user?.value(forKey: row.key()) as? String

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 192
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
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
