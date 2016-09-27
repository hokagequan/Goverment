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
    
    func didClickIndexPath(_ viewController: UIViewController, indexPath: IndexPath)
    func didClickSpecial(_ viewController: UIViewController)
    func checkIn(_ code: String, identifier: String, completion: @escaping (Bool) -> Void)
    
}
