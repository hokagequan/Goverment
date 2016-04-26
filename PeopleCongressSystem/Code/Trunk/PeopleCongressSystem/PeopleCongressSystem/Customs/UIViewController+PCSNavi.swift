//
//  UIViewController+PCSNavi.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/4/26.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func customPCSNavi(title: String) {
        let navi = PCSNavigationView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 30))
        navi.backgroundColor = UIColor.clearColor()
        navi.title = title
        navi.viewController = self
        self.view.addSubview(navi)
    }
    
}
