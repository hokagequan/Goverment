//
//  WorkerHomeActionDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/29.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

class WorkerHomeActionDelegate: ActionProtocol {
    
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
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableManager)
            vc.naviTitle = "履职管理"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Analyze:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableAnalyze)
            vc.naviTitle = "履职统计"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .ShareSpace:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLShareSpace)
            vc.naviTitle = "共享空间"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .CongressInfo:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLCongressInfo)
            vc.naviTitle = "代表信息"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Notify:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLNotify)
            vc.naviTitle = "通知通报"
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Situation:
            viewController.performSegueWithIdentifier("SituationSegue", sender: self)
            break
        default:
            break
        }
    }
    
}