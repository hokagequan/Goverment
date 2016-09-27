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
    var gotoPageType = VariablePageType.detail
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    @IBAction func clickAdd(_ sender: AnyObject) {
        gotoPageType = VariablePageType.add
        self.performSegue(withIdentifier: "VariableDetailSegue", sender: nil)
    }
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variables.count
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let variable = variables[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = variable.title
        
        let checkedString = variable.checked ? "已通过" : "未通过"
        let submitString = variable.submitted ? "已提交" : "未提交"
        cell.detailLabel.text = "\(checkedString) \(submitString)  \(variable.time!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let variable = variables[(indexPath as NSIndexPath).row]
        gotoPageType = VariablePageType.detail
        self.performSegue(withIdentifier: "VariableDetailSegue", sender: variable)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "VariableDetailSegue" {
            let vc = segue.destination as! VariableDetailViewController
            var object = sender as? Variable
            if object == nil {
                object = Variable()
            }
            
            vc.variable = object!
            vc.pageType = gotoPageType
        }
    }

}
