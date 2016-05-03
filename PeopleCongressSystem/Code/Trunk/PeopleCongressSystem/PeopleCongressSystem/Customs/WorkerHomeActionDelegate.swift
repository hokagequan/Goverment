//
//  WorkerHomeActionDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/29.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit
import EZLoadingActivity

class WorkerHomeActionDelegate: ActionProtocol {
    
    func checkIn(code: String, identifier: String, completion: (Bool) -> Void) {
        let range = code.rangeOfString(":")!
        let personID = code.substringToIndex(range.startIndex)
        let req = CheckInReq()
        req.activityID = identifier
        req.qrCodes = [personID]
        EZLoadingActivity.show("", disableUI: true)
        EZLoadingActivity.Settings.SuccessText = "签到成功"
        EZLoadingActivity.Settings.FailText = "签到失败"
        req.requestCompletion { (response) -> Void in
            let result = response?.result
            var success: Bool = false
            var errorCode: String? = nil
            
            defer {
                if success == true {
                    EZLoadingActivity.hide(success: true, animated: false)
                }
                else {
                    if errorCode != "-1" {
                        EZLoadingActivity.hide(success: false, animated: false)
                    }
                    else {
                        ResponseErrorManger.defaultManager().handleError(errorCode, message: nil)
                    }
                }
                
                completion(success)
            }
            
            if result?.isSuccess == true {
                guard let value = result?.value else {
                    success = false
                    
                    return
                }
                
                guard let responseString = HttpBaseReq.parseResponse(value) as? String else {
                    return
                }
                
                if ((responseString as NSString).intValue >= 1) {
                    success = true
                }
                else {
                    errorCode = responseString
                    success = false
                }
            }
            else {
                success = false
            }
        }
    }
    
    func didClickSpecial(viewController: UIViewController) {
        viewController.performSegueWithIdentifier("CheckInSegue", sender: self)
    }
    
    func didClickIndexPath(viewController: UIViewController, indexPath: NSIndexPath) {
        guard let row = HomeElementContentWorker(rawValue: indexPath.row) else {
            return
        }
        
        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch row {
        case .ActivityManage:
            viewController.performSegueWithIdentifier("PerformanceRecordsSegue", sender: self)
            break
        case .VariableManage:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableManagerWorker)
            vc.naviTitle = "履职管理"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Analyze:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableAnalyzeWorker)
            vc.naviTitle = "履职统计"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .ShareSpace:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLShareSpaceWorker)
            vc.naviTitle = "共享空间"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .CongressInfo:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLCongressInfoWorker)
            vc.naviTitle = "代表信息"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Notify:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLNotifyWorker)
            vc.naviTitle = "通知通报"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Situation:
            viewController.performSegueWithIdentifier("SituationSegue", sender: pageHTMLSituationWorker)
            break
        default:
            break
        }
    }
    
}