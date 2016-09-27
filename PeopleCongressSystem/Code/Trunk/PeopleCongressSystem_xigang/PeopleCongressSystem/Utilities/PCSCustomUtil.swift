//
//  PCSCustomUtil.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/18.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

class PCSCustomUtil: NSObject {
    
    class func customNavigationBar() {
        UINavigationBar.appearance().barTintColor = GlobalUtil.colorRGBA(230, g: 27, b: 39, a: 1.0)
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: ""), for: UIControlState(), barMetrics: UIBarMetrics.default)
    }
    
    class func customNavigationController(_ vc: UIViewController) {
        let image = UIImage(named: "guo_hui_small")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: image!.size.width * 0.8, height: image!.size.height * 0.8)
        let leftItem = UIBarButtonItem(customView: imageView)
        vc.navigationItem.leftBarButtonItem = leftItem
        vc.navigationItem.title = "人大代表履职信息管理系统"
        vc.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 15.0)]
    }
    
}
