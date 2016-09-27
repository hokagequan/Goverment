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
    
    func checkIn(_ code: String, identifier: String, completion: @escaping (Bool) -> Void) {
        let manager = QRCodeManager()
        _ = EZLoadingActivity.show("", disableUI: true)
        EZLoadingActivity.Settings.SuccessText = "签到成功"
        EZLoadingActivity.Settings.FailText = "签到失败"
        manager.handleCode(code, personID: PCSDataManager.defaultManager().accountManager.user!.congressID!) { (success, error) in
//            if error == nil {
                EZLoadingActivity.hide(success, animated: false)
//            }
            
            completion(success)
        }
    }
    
    func didClickSpecial(_ viewController: UIViewController) {
//        viewController.performSegueWithIdentifier("", sender: self)
    }
    
    func didClickIndexPath(_ viewController: UIViewController, indexPath: IndexPath) {
        guard let row = HomeElementContentCongress(rawValue: (indexPath as NSIndexPath).row) else {
            return
        }
        
        viewController.navigationController?.setNavigationBarHidden(false, animated: true)
        
        switch row {
        case .activityNotify:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLCongressNotify)
            vc.naviTitle = "活动提醒"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .variableRecords:
            viewController.performSegue(withIdentifier: "VariableRecordsSegue", sender: nil)
            break
        case .analyze:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableAnalyzeCongress)
            vc.naviTitle = "履职统计"
            vc.rightItemTitle = "详情"
            vc.rightItemBlock = {() -> Void in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let childVC = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
                childVC.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLAnalyzeDetailCongress)
                childVC.naviTitle = "履职统计详情"
                vc.navigationController?.pushViewController(childVC, animated: true)
            }
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .shareSpace:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLShareSpaceCongress)
            vc.naviTitle = "共享空间"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .congressInfo:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLCongressInfoCongress)
            vc.naviTitle = "代表风采"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .notify:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLNotifyCongress)
            vc.naviTitle = "通知通报"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .situation:
            viewController.performSegue(withIdentifier: "SituationSegue", sender: pageHtMLSituationCongress)
            break
        case .review:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLQuestionnaire)
            vc.naviTitle = "调查问卷"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .suggestion:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLAddSuggestion)
            vc.naviTitle = "建议意见"
            vc.rightItemTitle = "已提交列表"
            vc.rightItemBlock = {() -> Void in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let childVC = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
                childVC.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLSuggestion)
                childVC.naviTitle = "添加建议"
                vc.navigationController?.pushViewController(childVC, animated: true)
            }
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .vote:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVote)
            vc.naviTitle = "表决权"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
            
        default:
            break
        }
    }

    
}
