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
    
    func checkIn(_ code: String, identifier: String, completion: @escaping (Bool) -> Void) {
        let range = code.range(of: ":")!
        let personID = code.substring(to: range.lowerBound)
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
                    EZLoadingActivity.hide(true, animated: false)
                }
                else {
                    if errorCode != "-1" {
                        EZLoadingActivity.hide(false, animated: false)
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
    
    func didClickSpecial(_ viewController: UIViewController) {
        viewController.performSegue(withIdentifier: "CheckInSegue", sender: self)
    }
    
    func didClickIndexPath(_ viewController: UIViewController, indexPath: IndexPath) {
        guard let row = HomeElementContentWorker(rawValue: (indexPath as NSIndexPath).row) else {
            return
        }
        
        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch row {
        case .activityManage:
            viewController.performSegue(withIdentifier: "PerformanceRecordsSegue", sender: self)
            break
        case .variableManage:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableManagerWorker)
            vc.naviTitle = "履职管理"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .analyze:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableAnalyzeWorker)
            vc.naviTitle = "履职统计"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .shareSpace:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLShareSpaceWorker)
            vc.naviTitle = "共享空间"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .congressInfo:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLCongressInfoWorker)
            vc.naviTitle = "代表信息"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .notify:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLNotifyWorker)
            vc.naviTitle = "通知通报"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .situation:
            viewController.performSegue(withIdentifier: "SituationSegue", sender: pageHTMLSituationWorker)
            break
        default:
            break
        }
    }
    
}
