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
    
    func customPCSNavi(title: String) -> CGFloat {
        let naviHeight: CGFloat = 44.0
        let navi = PCSNavigationView(frame: CGRectMake(0, 0, self.view.bounds.size.width, naviHeight))
        navi.backgroundColor = UIColor.clearColor()
        navi.title = title
        navi.viewController = self
        self.view.addSubview(navi)
        
        return naviHeight
    }
    
    func customPCSNaviWithRightButton(title: String, button: UIButton) -> CGFloat {
        let naviHeight: CGFloat = 44.0
        let navi = PCSNavigationView(frame: CGRectMake(0, 0, self.view.bounds.size.width, naviHeight))
        navi.backgroundColor = UIColor.clearColor()
        navi.title = title
        navi.viewController = self
        self.view.addSubview(navi)
        
        var frame = button.frame
        frame.origin.x = navi.bounds.size.width - frame.size.width - 15
        button.frame = frame
        
        button.center = CGPointMake(button.center.x, navi.bounds.size.height / 2)
        navi.addSubview(button)
        
        return naviHeight
    }
    
}
