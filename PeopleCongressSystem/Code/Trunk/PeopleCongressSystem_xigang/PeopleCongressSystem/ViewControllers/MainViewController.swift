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
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.handleLogin(_:)), name: NSNotification.Name(rawValue: kNotificationPresentLogin), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.setupUntreatedApplyCount), name: NSNotification.Name(rawValue: "setupUntreatedApplyCount"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.setupUnreadMessageCount), name: NSNotification.Name(rawValue: "setupUnreadMessageCount"), object: nil)
        
        self.loadViewControllers()
        
        self.setupUnreadMessageCount()
        self.setupUntreatedApplyCount()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadViewControllers() {
        // 首页
        var storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeNavi = storyboard.instantiateViewController(withIdentifier: "HomeNavi")
        let homeTabItem = UITabBarItem(title: "首页", image: UIImage(named: "home_nor")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "home_sel")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        homeNavi.tabBarItem = homeTabItem
        
        // 聊天
        let chatViewController = ConversationListController(nibName: nil, bundle: nil)
        let chatNavi = UINavigationController(rootViewController: chatViewController)
        let chatTabItem = UITabBarItem(title: "会话", image: UIImage(named: "chat_nor")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "chat_sel")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        chatNavi.tabBarItem = chatTabItem
        ChatDemoHelper.share().conversationListVC = chatViewController
        
        // 联系人
        let contactsViewController = ContactListViewController(nibName: nil, bundle: nil)
        let contactsNavi = UINavigationController(rootViewController: contactsViewController)
        let contactsTabItem = UITabBarItem(title: "通讯录", image: UIImage(named: "contacts_nor")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "contacts_sel")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        contactsNavi.tabBarItem = contactsTabItem
        ChatDemoHelper.share().contactViewVC = contactsViewController
        
        // 我
        storyboard = UIStoryboard(name: "Me", bundle: nil)
        let meNavi = storyboard.instantiateViewController(withIdentifier: "MeNavi")
        let meTabItem = UITabBarItem(title: "我", image: UIImage(named: "me_nor")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "me_sel")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal))
        meNavi.tabBarItem = meTabItem
        
        CustomObjectUtil.customTabbarItem([homeTabItem, chatTabItem, contactsTabItem, meTabItem], titleColor: GlobalUtil.colorRGBA(132, g: 132, b: 132, a: 1.0), font: UIFont.systemFont(ofSize: 10.0), state: UIControlState())
        CustomObjectUtil.customTabbarItem([homeTabItem, chatTabItem, contactsTabItem, meTabItem], titleColor: UIColor.red, font: UIFont.systemFont(ofSize: 10.0), state: UIControlState.selected)
        
        self.setViewControllers([homeNavi, chatNavi, contactsNavi, meNavi], animated: false)
    }
    
    // MARK: - Observer
    
    func handleLogin(_ notification: Notification) {
        self.performSegue(withIdentifier: "BackToSignIn", sender: nil)
    }
    
    func setupUnreadMessageCount() {
        guard let conversations = EMClient.shared().chatManager.getAllConversations() as? Array<EMConversation> else {
            return
        }
        
        var chatListViewController: ConversationListController? = nil
        
        for viewController in self.viewControllers! {
            if viewController is ConversationListController {
                chatListViewController = viewController as? ConversationListController
                break
            }
        }
        
        if chatListViewController == nil {
            return
        }
        
        var unreadCount: Int32 = 0
        
        for conversation in conversations {
            unreadCount += conversation.unreadMessagesCount
        }
        
        if unreadCount > 0 {
            chatListViewController?.tabBarItem.badgeValue = "\(unreadCount)"
        }
        else {
            chatListViewController?.tabBarItem.badgeValue = nil
        }
        
        UIApplication.shared.applicationIconBadgeNumber = Int(unreadCount)
    }
    
    func setupUntreatedApplyCount() {
        var contactsViewController: ContactListViewController? = nil
        
        for viewController in self.viewControllers! {
            if viewController is ContactListViewController {
                contactsViewController = viewController as? ContactListViewController
                break
            }
        }
        
        if contactsViewController == nil {
            return
        }
        
        let unreadCount = ApplyViewController.share().dataSource.count
        
        if unreadCount > 0 {
            contactsViewController?.tabBarItem.badgeValue = "\(unreadCount)"
        }
        else {
            contactsViewController?.tabBarItem.badgeValue = nil
        }
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
