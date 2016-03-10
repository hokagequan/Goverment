//
//  CongressHomeActionDelegate.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/10.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

class CongressHomeActionDelegate: ActionProtocol {
    
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
            viewController.navigationController?.pushViewController(vc, animated: true)
            break
        case .VariableRecords:
            viewController.performSegueWithIdentifier("VariableRecordsSegue", sender: nil)
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
            viewController.performSegueWithIdentifier("SituationSegue", sender: self)
            break
        default:
            break
        }
    }

    
}