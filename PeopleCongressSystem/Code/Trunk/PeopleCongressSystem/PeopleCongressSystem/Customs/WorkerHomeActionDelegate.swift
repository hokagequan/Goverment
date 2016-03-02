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
        
        // TODO:
        switch row {
        case .ActivityManage:
            viewController.navigationController?.setNavigationBarHidden(false, animated: true)
            viewController.performSegueWithIdentifier("PerformanceRecordsSegue", sender: self)
            break
        case .VariableManage:
            break
        case .Analyze:
            break
        case .ShareSpace:
            break
        case .CongressInfo:
            break
        case .Notify:
            break
        case .Situation:
            break
        default:
            break
        }
    }
    
}