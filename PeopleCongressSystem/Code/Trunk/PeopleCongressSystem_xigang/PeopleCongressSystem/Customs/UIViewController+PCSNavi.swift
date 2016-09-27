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
    
    func customPCSNavi(_ title: String) -> CGFloat {
        let naviHeight: CGFloat = 44.0
        let navi = PCSNavigationView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: naviHeight))
        navi.backgroundColor = UIColor.clear
        navi.title = title
        navi.viewController = self
        self.view.addSubview(navi)
        
        return naviHeight
    }
    
    func customPCSNaviWithRightButton(_ title: String, button: UIButton) -> CGFloat {
        let naviHeight: CGFloat = 44.0
        let navi = PCSNavigationView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: naviHeight))
        navi.backgroundColor = UIColor.clear
        navi.title = title
        navi.viewController = self
        self.view.addSubview(navi)
        
        var frame = button.frame
        frame.origin.x = navi.bounds.size.width - frame.size.width - 15
        button.frame = frame
        
        button.center = CGPoint(x: button.center.x, y: navi.bounds.size.height / 2)
        navi.addSubview(button)
        
        return naviHeight
    }
    
    func customPCSNaviWithRightButton(_ title: String, button: UIButton, hideBack: Bool) -> CGFloat {
        let naviHeight: CGFloat = 44.0
        let navi = PCSNavigationView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: naviHeight))
        navi.backgroundColor = UIColor.clear
        navi.title = title
        navi.viewController = self
        navi.backHidden = hideBack
        self.view.addSubview(navi)
        
        var frame = button.frame
        frame.origin.x = navi.bounds.size.width - frame.size.width - 15
        button.frame = frame
        
        button.center = CGPoint(x: button.center.x, y: navi.bounds.size.height / 2)
        navi.addSubview(button)
        
        return naviHeight
    }
    
}
