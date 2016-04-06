//
//  MainViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/1/18.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadViewControllers() {
        // 首页
        var storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeNavi = storyboard.instantiateViewControllerWithIdentifier("HomeNavi")
        let homeTabItem = UITabBarItem(title: "首页", image: UIImage(named: "home_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "home_sel")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
        homeNavi.tabBarItem = homeTabItem
        
        var customNavi: UIViewController?
        var customTabItem: UITabBarItem?
        if PCSDataManager.defaultManager().content is CongressContentInfo {
            // 名片
            storyboard = UIStoryboard(name: "BusinessCard", bundle: nil)
            customNavi = storyboard.instantiateViewControllerWithIdentifier("BusinessCardNavi")
            customTabItem = UITabBarItem(title: "名片", image: UIImage(named: "business_card_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "business_card_sel")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
            customNavi!.tabBarItem = customTabItem
        }
        else {
            // 签到
            storyboard = UIStoryboard(name: "CheckIn", bundle: nil)
            customNavi = storyboard.instantiateViewControllerWithIdentifier("CheckInNavi")
            customTabItem = UITabBarItem(title: "签到", image: UIImage(named: "checkin_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "checkin_sel")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
            customNavi!.tabBarItem = customTabItem
        }
        
        // 我
        storyboard = UIStoryboard(name: "Me", bundle: nil)
        let meNavi = storyboard.instantiateViewControllerWithIdentifier("MeNavi")
        let meTabItem = UITabBarItem(title: "我", image: UIImage(named: "me_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "me_sel")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
        meNavi.tabBarItem = meTabItem
        
        CustomObjectUtil.customTabbarItem([homeTabItem, customTabItem!, meTabItem], titleColor: GlobalUtil.colorRGBA(132, g: 132, b: 132, a: 1.0), font: UIFont.systemFontOfSize(10.0), state: UIControlState.Normal)
        CustomObjectUtil.customTabbarItem([homeTabItem, customTabItem!, meTabItem], titleColor: UIColor.redColor(), font: UIFont.systemFontOfSize(10.0), state: UIControlState.Selected)
        
        self.setViewControllers([homeNavi, customNavi!, meNavi], animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
