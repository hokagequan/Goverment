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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.handleLogin(_:)), name: kNotificationPresentLogin, object: nil)
        
        self.loadViewControllers()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        
        // 聊天
        let chatViewController = ConversationListController(nibName: nil, bundle: nil)
        let chatNavi = UINavigationController(rootViewController: chatViewController)
        let chatTabItem = UITabBarItem(title: "会话", image: UIImage(named: "chat_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "chat_sel")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
        chatNavi.tabBarItem = chatTabItem
        
        // 联系人
        let contactsViewController = ContactListViewController(nibName: nil, bundle: nil)
        let contactsNavi = UINavigationController(rootViewController: contactsViewController)
        let contactsTabItem = UITabBarItem(title: "通讯录", image: UIImage(named: "contacts_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "contacts_sel")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
        contactsNavi.tabBarItem = contactsTabItem
        
        // 我
        storyboard = UIStoryboard(name: "Me", bundle: nil)
        let meNavi = storyboard.instantiateViewControllerWithIdentifier("MeNavi")
        let meTabItem = UITabBarItem(title: "我", image: UIImage(named: "me_nor")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "me_sel")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal))
        meNavi.tabBarItem = meTabItem
        
        CustomObjectUtil.customTabbarItem([homeTabItem, chatTabItem, contactsTabItem, meTabItem], titleColor: GlobalUtil.colorRGBA(132, g: 132, b: 132, a: 1.0), font: UIFont.systemFontOfSize(10.0), state: UIControlState.Normal)
        CustomObjectUtil.customTabbarItem([homeTabItem, chatTabItem, contactsTabItem, meTabItem], titleColor: UIColor.redColor(), font: UIFont.systemFontOfSize(10.0), state: UIControlState.Selected)
        
        self.setViewControllers([homeNavi, chatNavi, contactsNavi, meNavi], animated: false)
    }
    
    // MARK: - Observer
    
    func handleLogin(notification: NSNotification) {
        self.performSegueWithIdentifier("BackToSignIn", sender: nil)
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
