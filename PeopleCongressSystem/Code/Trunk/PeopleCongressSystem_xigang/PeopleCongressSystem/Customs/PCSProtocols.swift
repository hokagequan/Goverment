//
//  PCSProtocols.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/29.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

protocol ActionProtocol {
    
    func didClickIndexPath(viewController: UIViewController, indexPath: NSIndexPath)
    func didClickSpecial(viewController: UIViewController)
    func checkIn(code: String, identifier: String, completion: (Bool) -> Void)
    
}