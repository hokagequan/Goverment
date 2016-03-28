//
//  CommonHTMLViewController.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import UIKit
import EZLoadingActivity

class CommonHTMLViewController: UIViewController, WebViewHTMLProtocol, PCSNavigationViewDelegate {

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
        naviView.delegate = self
        rightItem.setTitle(rightItemTitle, forState: UIControlState.Normal)
        self.loadWebView(webViewContainer)
        self.loadMainPage()
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
    
    // MARK: - PCSNaviViewDelegate
    
    func willDismiss() -> Bool {
        EZLoadingActivity.show("", disableUI: true)
        let req = GetUrlReq()
        req.requestSimpleCompletion { (success, url) -> Void in
            EZLoadingActivity.hide()
            
            if url == nil {
                self.navigationController?.popViewControllerAnimated(true)
                return
            }
            
            self.URL = url
            self.loadMainPage()
        }
        
        return true
    }
    
    // MARK: - UIWebView
    
    override func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        super.webView(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
        
//        if firstLoad == true {
//            firstLoad = false
//            return rel
//        }
        
        if request.URL != nil && request.URL!.absoluteString.containsString("login.aspx") {
            self.performSegueWithIdentifier("LogoutSegue", sender: nil)
            
            return false
        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewControllerWithIdentifier("CommonHTMLViewController") as! CommonHTMLViewController
//        vc.URL = request.URL?.absoluteString
//        vc.naviTitle = self.naviTitle
//        self.navigationController?.pushViewController(vc, animated: true)
        
        return true
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
