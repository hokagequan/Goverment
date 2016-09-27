//
//  PerformanceRecordsViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

enum ManagePageType {
    case activity
    case variable
}

class PerformanceRecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TypeSelectViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
    var activitys = [Activity]()
    var allActivitys = [Activity]()
    var types = [PCSTypeInfo]()
    var selectedObject: AnyObject? = nil
    var selectedType: PCSTypeInfo?
    var gotoPageType: EditPageType = EditPageType.activity
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        listTableView.register(UINib(nibName: "NormalInfoCell", bundle: nil), forCellReuseIdentifier: "NormalInfoCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedObject = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getActivityList("") { (info, errorCode) -> Void in
            EZLoadingActivity.hide()
            
            if info != nil {
                self.allActivitys = info!
                self.refreshTableView()
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
    
    func refreshTableView() {
        if selectedType == nil {
            activitys = allActivitys
        }
        else {
            activitys = allActivitys.filter({ (activity) -> Bool in
                return activity.type! == self.selectedType!.code!
            })
        }
        
        listTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func clickAdd(_ sender: AnyObject) {
        gotoPageType = EditPageType.activity
        self.performSegue(withIdentifier: "EditSegue", sender: self)
    }
    
    // MARK: - TypeSelectViewDelegate
    
    func didSelectIndex(_ view: TypeSelectView, indexPath: IndexPath) {
        selectedType = types[(indexPath as NSIndexPath).row]
        
        self.refreshTableView()
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activitys.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).row == 0 {
            return 52.0
        }
        
        return 83.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.contentView.viewWithTag(1000) != nil {
            return
        }
        
        let frame = CGRect(x: 5, y: 4, width: cell.bounds.size.width - 10, height: cell.bounds.size.height - 8)
        let view = UIView(frame: frame)
        view.tag = 1000
        CustomObjectUtil.customObjectsLayout([view], backgroundColor: UIColor.white, borderWidth: 1, borderColor: GlobalUtil.colorRGBA(230, g: 230, b: 230, a: 1.0), corner: 2)
        cell.contentView.addSubview(view)
        cell.contentView.sendSubview(toBack: view)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            cell.imageView?.image = UIImage(named: "categroy")
            cell.textLabel?.text = "活动分类"
            
            if selectedType == nil {
                cell.detailTextLabel?.text = "请选择"
            }
            else {
                cell.detailTextLabel?.text = selectedType?.title
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalInfoCell", for: indexPath) as! NormalInfoCell
        cell.backgroundColor = UIColor.clear
        
        let index = (indexPath as NSIndexPath).row - 1
        let activity = activitys[index]
        cell.titleLabel.text = activity.title
        cell.locationLabel.text = activity.organization
        cell.dateLabel.text = activity.beginTime?.substring(to: activity.beginTime!.characters.index(activity.beginTime!.startIndex, offsetBy: 10))
        cell.iconImageView.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath as NSIndexPath).row == 0 {
            EZLoadingActivity.show("", disableUI: true)
            PCSDataManager.defaultManager().getTypeInfo(PCSType.Congress) { (infos, errorCode) -> Void in
                EZLoadingActivity.hide()
                if infos != nil {
                    self.types = infos!
                    let typeView = TypeSelectView.view()
                    typeView.dataSource = self.types.flatMap({return $0.title})
                    typeView.delegate = self
                    typeView.show()
                }
            }
            
            return
        }
        
        let activity = activitys[(indexPath as NSIndexPath).row - 1]
        selectedObject = activity
        gotoPageType = EditPageType.activityEdit
        self.performSegue(withIdentifier: "EditSegue", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EditSegue" {
            let vc = segue.destination as! PerformanceEditViewController
            vc.pageType = gotoPageType
            vc.editObject = selectedObject ?? Activity()
        }
    }

}
