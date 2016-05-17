//
//  CongressHomeActionDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/10.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit
import EZLoadingActivity

class CongressHomeActionDelegate: ActionProtocol {
    
    func checkIn(code: String, identifier: String, completion: (Bool) -> Void) {
        let manager = QRCodeManager()
        EZLoadingActivity.show("", disableUI: true)
        EZLoadingActivity.Settings.SuccessText = "签到成功"
        EZLoadingActivity.Settings.FailText = "签到失败"
        manager.handleCode(code, personID: PCSDataManager.defaultManager().accountManager.user!.congressID!) { (success, error) in
//            if error == nil {
                EZLoadingActivity.hide(success: success, animated: false)
//            }
            
            completion(success)
        }
    }
    
    func didClickSpecial(viewController: UIViewController) {
//        viewController.performSegueWithIdentifier("", sender: self)
    }
    
    func didClickIndexPath(viewController: UIViewController, indexPath: NSIndexPath) {
        guard let row = HomeElementContentCongress(rawValue: indexPath.row) else {
            return
        }
        
        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch row {
        case .ActivityNotify:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLCongressNotify)
            vc.naviTitle = "活动提醒"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .VariableRecords:
            viewController.performSegueWithIdentifier("VariableRecordsSegue", sender: nil)
            break
        case .Analyze:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableAnalyzeCongress)
            vc.naviTitle = "履职统计"
            vc.rightItemTitle = "详情"
            vc.rightItemBlock = {() -> Void in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let childVC = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
                childVC.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLAnalyzeDetailCongress)
                childVC.naviTitle = "履职统计详情"
                vc.navigationController?.pushViewController(childVC, animated: true)
            }
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .ShareSpace:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLShareSpaceCongress)
            vc.naviTitle = "共享空间"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .CongressInfo:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLCongressInfoCongress)
            vc.naviTitle = "代表风采"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Notify:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLNotifyCongress)
            vc.naviTitle = "通知通报"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Situation:
            viewController.performSegueWithIdentifier("SituationSegue", sender: pageHtMLSituationCongress)
            break
        case .Review:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLQuestionnaire)
            vc.naviTitle = "调查问卷"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Suggestion:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLQuestionnaire)
            vc.naviTitle = "建议意见"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        default:
            break
        }
    }

    
}