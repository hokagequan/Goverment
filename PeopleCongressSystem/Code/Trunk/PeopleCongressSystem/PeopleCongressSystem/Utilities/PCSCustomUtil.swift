//
//  PCSCustomUtil.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/2/18.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

class PCSCustomUtil {
    
    class func customNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.redColor()
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage(named: ""), forState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
    }
    
    class func customNavigationController(vc: UIViewController) {
        let image = UIImage(named: "guo_hui_small")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRectMake(0, 0, image!.size.width * 0.8, image!.size.height * 0.8)
        let leftItem = UIBarButtonItem(customView: imageView)
        vc.navigationItem.leftBarButtonItem = leftItem
        vc.navigationItem.title = "大连市人大代表履职信息管理系统"
        vc.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(15.0)]
    }
    
}