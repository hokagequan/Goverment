//
//  VariableManageViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/5.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class VariableRecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listTableView: UITableView!
    
    var variables = [Variable]()
    var gotoPageType = VariablePageType.Detail
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().getVariableList { (info, errorCode) -> Void in
            EZLoadingActivity.hide()
            
            if info != nil {
                self.variables = info!
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
    
    // MARK: - Actions
    
    @IBAction func clickAdd(sender: AnyObject) {
        gotoPageType = VariablePageType.Add
        self.performSegueWithIdentifier("VariableDetailSegue", sender: nil)
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variables.count
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.contentView.viewWithTag(1000) != nil {
            return
        }
        
        let frame = CGRectMake(5, 4, cell.bounds.size.width - 10, cell.bounds.size.height - 8)
        let view = UIView(frame: frame)
        view.tag = 1000
        CustomObjectUtil.customObjectsLayout([view], backgroundColor: UIColor.whiteColor(), borderWidth: 1, borderColor: GlobalUtil.colorRGBA(240, g: 240, b: 240, a: 1.0), corner: 2)
        cell.contentView.addSubview(view)
        cell.contentView.sendSubviewToBack(view)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecordCell", forIndexPath: indexPath) as! RecordCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let variable = variables[indexPath.row]
        cell.titleLabel.text = variable.title
        
        let checkedString = variable.checked ? "已通过" : "未通过"
        let submitString = variable.submitted ? "已提交" : "未提交"
        cell.detailLabel.text = "\(checkedString) \(submitString)  \(variable.time!)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let variable = variables[indexPath.row]
        gotoPageType = VariablePageType.Detail
        self.performSegueWithIdentifier("VariableDetailSegue", sender: variable)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "VariableDetailSegue" {
            let vc = segue.destinationViewController as! VariableDetailViewController
            var object = sender as? Variable
            if object == nil {
                object = Variable()
            }
            
            vc.variable = object!
            vc.pageType = gotoPageType
        }
    }

}
