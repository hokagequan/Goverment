//
//  CustomObjectUtil.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/19.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

class CustomObjectUtil {
    
    class func customObjectsLayout(_ objects: Array<UIView>, backgroundColor: UIColor?, borderWidth: CGFloat, borderColor: UIColor?, corner: CGFloat) {
        for view in objects {
            view.backgroundColor = backgroundColor;
            view.layer.borderWidth = borderWidth;
            view.layer.borderColor = borderColor?.cgColor;
            view.layer.cornerRadius = corner;
            view.layer.masksToBounds = true;
        }
    }
    
    class func customTabbarItem(_ items: Array<UITabBarItem>, titleColor: UIColor, font: UIFont, state: UIControlState) {
        for item in items {
            item.setTitleTextAttributes([NSForegroundColorAttributeName: titleColor, NSFontAttributeName: font], for: state)
        }
    }
    
}
