//
//  CheckInViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/6.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class CheckInViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
    var activitys = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PCSCustomUtil.customNavigationController(self)
        
        listTableView.register(UINib(nibName: "NormalInfoCell", bundle: nil), forCellReuseIdentifier: "NormalInfoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getActivityList("") { (info, errorCode) -> Void in
            EZLoadingActivity.hide()
            if info != nil {
                self.activitys = info!
                self.listTableView.reloadData()
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitys.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.contentView.viewWithTag(1000) != nil {
            return
        }
        
        let frame = CGRect(x: 5, y: 4, width: cell.bounds.size.width - 10, height: cell.bounds.size.height - 8)
        let view = UIView(frame: frame)
        view.tag = 1000
        CustomObjectUtil.customObjectsLayout([view], backgroundColor: UIColor.white, borderWidth: 1, borderColor: GlobalUtil.colorRGBA(240, g: 240, b: 240, a: 1.0), corner: 2)
        cell.contentView.addSubview(view)
        cell.contentView.sendSubview(toBack: view)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalInfoCell", for: indexPath) as! NormalInfoCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let activity = activitys[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = activity.title
        cell.locationLabel.text = activity.organization
        cell.dateLabel.text = activity.beginTime?.substring(to: activity.beginTime!.characters.index(activity.beginTime!.startIndex, offsetBy: 10))
        cell.backgroundColor = UIColor.clear
        cell.iconImageView.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PerformanceEditViewController") as! PerformanceEditViewController
        vc.pageType = EditPageType.checkIn
        let activity = activitys[(indexPath as NSIndexPath).row]
        vc.editObject = activity.copy() as AnyObject?
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
