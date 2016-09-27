//
//  GroupViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/3.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var groupTableView: UITableView!
    
    var groups = [Group]()
    var activity: Activity? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        groupTableView.layoutMargins = UIEdgeInsets.zero
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getGroup { (info, errorCode) -> Void in
            EZLoadingActivity.hide()
            if info != nil {
                self.groups = info!
                
                self.groupTableView.reloadData()
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.imageView?.image = UIImage(named: "star")
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.textLabel?.textColor = GlobalUtil.colorRGBA(38, g: 38, b: 38, a: 1)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15.0)
        
        let group = groups[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = group.title! + "（\(group.personCount)）"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let group = groups[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "PersonListSegue", sender: group)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PersonListSegue" {
            let vc = segue.destination as! PersonListViewController
            vc.activity = activity
            vc.group = sender as? Group
            vc.backTitle = "完成"
        }
    }

}
