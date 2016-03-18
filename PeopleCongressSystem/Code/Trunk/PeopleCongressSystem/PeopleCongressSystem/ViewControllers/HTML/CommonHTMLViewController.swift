//
//  CommonHTMLViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit

class CommonHTMLViewController: UIViewController, WebViewHTMLProtocol {

    @IBOutlet weak var naviView: PCSNavigationView!
    @IBOutlet weak var webViewContainer: UIView!
    
    var URL: String?
    var naviTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        self.naviView.title = naviTitle
        self.loadWebView(webViewContainer)
        self.loadMainPage()
        self.htmlWebView.backgroundColor = UIColor.clearColor()
        webViewContainer.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMainPage() {
        if URL == nil {
            return
        }
        
        let req = NSURLRequest(URL: NSURL(string: URL!)!)
        self.htmlWebView.loadRequest(req)
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
