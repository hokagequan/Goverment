//
//  ManageEditUIActivityDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/5.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit
import EZLoadingActivity

class ManageEditUIActivityDelegate: ManageEditUIDelegate {
    
    var types = [PCSTypeInfo]()
    var selectedInfo: PCSTypeInfo? = nil
    
    func createActivity() -> Activity {
        var activity = Activity()
        
        if self.editObject != nil {
            activity = (self.editObject as! Activity).copy() as! Activity
        }
        
        for section in 0..<EditSections.max.rawValue {
            let sec = EditSections(rawValue: section)
            let rowCount = sec?.rows().count
            
            for row in 0..<rowCount! {
                let cell = tableView!.cellForRow(at: IndexPath(row: row, section: section))
                if cell is NormalImageTableCell {
                    let row = sec!.rows()[row]
                    activity.setValue((cell as! NormalImageTableCell).titleTextField.text, forKey: row.key!)
                }
            }
        }
        
        if selectedInfo != nil {
            activity.type = selectedInfo?.code
        }
        
        return activity
    }
    
    func verify() -> Bool {
        let activity = self.editObject as! Activity
        if activity.title == nil {
            GlobalUtil.showAlert("请填写标题")
            
            return false
        }
        
        if activity.type == nil {
            GlobalUtil.showAlert("请选择类型")
            
            return false
        }
        
        if activity.organization == nil {
            GlobalUtil.showAlert("请填写组织名称")
            
            return false
        }
        
        if activity.beginTime == nil {
            GlobalUtil.showAlert("请填写开始时间")
            
            return false
        }
        
        if activity.endTime == nil {
            GlobalUtil.showAlert("请填写结束时间")
            
            return false
        }
        
        if activity.location == nil {
            GlobalUtil.showAlert("请填写地点")
            
            return false
        }
        
        if activity.content == nil {
            GlobalUtil.showAlert("请填写内容")
            
            return false
        }
        
        if activity.persons?.count == 0 {
            GlobalUtil.showAlert("请选择人员")
            
            return false
        }
        
        return true
    }
    
    // MARK: - Override
    
    override func save() {
        self.editObject = self.createActivity()
        
        if self.verify() == false {
            return
        }
        
        EZLoadingActivity.show("", disableUI: true)
        PCSDataManager.defaultManager().addActivity(self.editObject as! Activity) { (success, message, errorCode) -> Void in
            EZLoadingActivity.hide()
            
            if success {
                GlobalUtil.showAlert("添加成功")
                self.masterViewController?.navigationController?.popViewController(animated: true)
            }
            else {
                ResponseErrorManger.defaultManager().handleError(errorCode, message: message)
            }
        }
    }
    
    // MARK: - TypeSelectViewDelegate
    
    func didSelectIndex(_ view: TypeSelectView, indexPath: IndexPath) {
        selectedInfo = types[(indexPath as NSIndexPath).row]
        tableView?.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.none)
    }
    
    // MARK: - CellDelegate
    
    override func didEndEditing(_ cell: NormalImageTableCell) {
        super.didEndEditing(cell)
        let indexPath = tableView?.indexPath(for: cell)
        let activity = self.editObject as? Activity
        let section = EditSections(rawValue: (indexPath! as NSIndexPath).section)!
        let row = section.rows()[(indexPath! as NSIndexPath).row]
        activity?.setValue(cell.titleTextField.text, forKey: row.key!)
    }
    
    // MARK: - UITableView
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = EditSections(rawValue: (indexPath as NSIndexPath).section)!
        let row = section.rows()[(indexPath as NSIndexPath).row]
        
        switch row.title! {
        case "人员:":
            let activity = self.editObject as? Activity
            return TagListCell.cellHeight(activity?.persons)
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let activity = self.editObject as? Activity
        let section = EditSections(rawValue: (indexPath as NSIndexPath).section)!
        let row = section.rows()[(indexPath as NSIndexPath).row]
        if cell is NormalImageTableCell {
            switch row.title! {
            case "标题:":
                (cell as! NormalImageTableCell).titleTextField.text = activity?.title
                break
            case "类型:":
                (cell as! NormalImageTableCell).titleTextField.text = selectedInfo != nil ? selectedInfo?.title : activity?.typeTitle
                break
            case "组织:":
                (cell as! NormalImageTableCell).titleTextField.text = activity?.organization
                break
            case "开始时间:":
                (cell as! NormalImageTableCell).titleTextField.text = activity?.beginTime
                break
            case "结束时间:":
                (cell as! NormalImageTableCell).titleTextField.text = activity?.endTime
                break
            case "地址:":
                (cell as! NormalImageTableCell).titleTextField.text = activity?.location
                break
            case "内容:":
                (cell as! NormalImageTableCell).titleTextField.text = activity?.content
                break
            default:
                break
            }
        }
        else if cell is TagListCell {
            (cell as! TagListCell).loadPersons(activity?.persons)
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = EditSections(rawValue: (indexPath as NSIndexPath).section)!
        let row = section.rows()[(indexPath as NSIndexPath).row]
        switch row.title! {
        case "类型:":
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
            
            break
        case "开始时间:", "结束时间:":
            let cell = tableView.cellForRow(at: indexPath) as! NormalImageTableCell
            cell.titleTextField.becomeFirstResponder()
            break
        case "人员:":
            if self.editObject == nil {
                self.editObject = self.createActivity()
            }
            self.masterViewController?.performSegue(withIdentifier: "GroupSegue", sender: self)
            break
        default:
            break
        }
    }
    
}
