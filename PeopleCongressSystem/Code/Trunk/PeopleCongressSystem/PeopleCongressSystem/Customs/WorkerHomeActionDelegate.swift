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
        
        // TODO:
        switch row {
        case .ActivityManage:
            viewController.performSegueWithIdentifier("PerformanceRecordsSegue", sender: self)
            break
        case .VariableManage:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableManager)
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Analyze:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLVariableAnalyze)
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .ShareSpace:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLShareSpace)
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .CongressInfo:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLCongressInfo)
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Notify:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
            vc.URL = PCSDataManager.defaultManager().htmlURL(pageHTMLNotify)
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .Situation:
            break
        default:
            break
        }
    }
    
}