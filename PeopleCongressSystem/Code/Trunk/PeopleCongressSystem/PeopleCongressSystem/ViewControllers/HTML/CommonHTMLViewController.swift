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
    @IBOutlet weak var rightItem: UIButton!
    @IBOutlet weak var webViewContainer: UIView!
    
    var URL: String?
    var naviTitle: String?
    var rightItemTitle: String?
    var firstLoad = true
    var rightItemBlock: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.hidesBackButton = true
        PCSCustomUtil.customNavigationController(self)
        
        naviView.title = naviTitle
        rightItem.setTitle(rightItemTitle, forState: UIControlState.Normal)
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
    
    // MARK: - Actions
    
    @IBAction func clickRightItem(sender: AnyObject) {
        rightItemBlock?()
    }
    
    // MARK: - UIWebView
    
    override func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let rel = super.webView(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
        
        if firstLoad == true {
            firstLoad = false
            return rel
        }
        
        if request.URL != nil && request.URL!.absoluteString.containsString("login.aspx") {
            self.performSegueWithIdentifier("LogoutSegue", sender: nil)
            
            return false
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
        vc.URL = request.URL?.absoluteString
        vc.naviTitle = self.naviTitle
        self.navigationController?.pushViewController(vc, animated: true)
        
        return false
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
