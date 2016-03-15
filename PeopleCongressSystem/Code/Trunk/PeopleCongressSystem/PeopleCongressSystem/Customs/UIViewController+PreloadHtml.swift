//
//  UIViewController+Preload.swift
//  SuperGome
//
//  Created by Q on 15/12/10.
//  Copyright © 2015年 EADING. All rights reserved.
//

import Foundation
import UIKit

protocol WebViewHTMLProtocol {
    func loadMainPage()
}

extension UIViewController: UIWebViewDelegate {
    
    typealias HtmlLoadCompletion = @convention(block)(Bool) -> Void
    
    private struct AssociatedKeys {
        static var htmlWebView = "htmlWebView"
        static var loadCompletion = "loadCompletion"
        static var parentViewController = "parentViewController"
    }
    
    var htmlWebView: UIWebView {
        get {
            var webView = objc_getAssociatedObject(self, &AssociatedKeys.htmlWebView) as? UIWebView
            
            if webView == nil {
                webView = UIWebView()
                webView?.backgroundColor = UIColor.clearColor()
                objc_setAssociatedObject(self, &AssociatedKeys.htmlWebView, webView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            
            return webView!
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.htmlWebView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var loadCompletion: HtmlLoadCompletion? {
        get {
            if let block = objc_getAssociatedObject(self, &AssociatedKeys.loadCompletion) {
                return unsafeBitCast(block, HtmlLoadCompletion.self)
            }
            
            return nil
        }
        set {
            if let value = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.loadCompletion, unsafeBitCast(value, AnyObject.self), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            else {
                objc_setAssociatedObject(self, &AssociatedKeys.loadCompletion, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    private weak var parentViewController: UIViewController? {
        get {
            let vc = objc_getAssociatedObject(self, &AssociatedKeys.parentViewController) as? UIViewController
            
            return vc
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.parentViewController, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func loadPageCompletion(fromViewController: UIViewController?, completion: ((Bool) -> Void)?) {
        fromViewController?.view.userInteractionEnabled = false
        self.parentViewController = fromViewController
        
        loadCompletion = completion
        htmlWebView.delegate = self
        htmlWebView.frame = self.view.bounds
        htmlWebView.scrollView.scrollEnabled = false
        
        if self.respondsToSelector("loadMainPage") {
            self.performSelector("loadMainPage")
        }
    }
    
    func loadWebView(container: UIView) {
        self.htmlWebView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self.htmlWebView)
        
        let HLC = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.htmlWebView])
        let VLC = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": self.htmlWebView])
        container.addConstraints(HLC)
        container.addConstraints(VLC)
    }
    
    // MARK: - UIWebViewDelegate
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        self.parentViewController?.view.userInteractionEnabled = true
        webView.stringByEvaluatingJavaScriptFromString("document.documentElement.style.webkitUserSelect='none';")
        
        loadCompletion?(true)
        loadCompletion = nil
    }
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if webView.hasHtmlCall(request) {
            webView.analysisHtmlCall(request)
            
            return false
        }
        
        return true
    }
    
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        self.parentViewController?.view.userInteractionEnabled = true
        
        loadCompletion?(false)
        loadCompletion = nil
    }
    
}