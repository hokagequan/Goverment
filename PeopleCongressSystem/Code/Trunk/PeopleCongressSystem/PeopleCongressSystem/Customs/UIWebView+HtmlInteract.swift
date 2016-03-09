//
//  UIWebView+HtmlInteract.swift
//  PeopleCongressSystem
//
//  Created by Matt Quan on 16/3/9.
//  Copyright © 2016年 CoolRabbit. All rights reserved.
//

import Foundation
import UIKit

@objc protocol UIWebViewHtmlDelegate {
    
}

extension UIWebView {
    
    private struct AssociatedKeys {
        static var htmlDelegate = "htmlDelegate"
    }
    
    var htmlDelegate: UIWebViewHtmlDelegate? {
        get {
            let delegate = objc_getAssociatedObject(self, &AssociatedKeys.htmlDelegate)
            
            return delegate as? UIWebViewHtmlDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.htmlDelegate, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func analysisHtmlCall(request: NSURLRequest) {
        let requestURLString = request.URL?.absoluteString
        
        guard let components = requestURLString?.componentsSeparatedByString(":") else {
            return
        }
        
        let commandName = components[1]
        var args = [String: String]()
        
        if components.count > 2 {
            let argsString = components[2].stringByRemovingPercentEncoding
            
            guard let argsData = argsString?.dataUsingEncoding(NSUTF8StringEncoding) else {
                return
            }
            
            do {
                args = try NSJSONSerialization.JSONObjectWithData(argsData, options: NSJSONReadingOptions.MutableContainers) as! [String : String]
                self.callback(commandName, args: args)
            }
            catch {}
        }
    }
    
    func htmlRequest(method: String?, params: AnyObject?) {
        var jsCommand: String = ""
        var jsParams = ""
        
        defer {
            if method != nil {
                jsCommand = "\(method)(\(jsParams))"
            }
            else {
                jsCommand = jsParams
            }
            
            self.stringByEvaluatingJavaScriptFromString(jsCommand)
        }
        
        if (params != nil) {
            if params is Dictionary<String, AnyObject> {
                do {
                    let paramsData = try NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted)
                    jsParams = String(data: paramsData, encoding: NSUTF8StringEncoding)!
                }
                catch {}
            }
            else if params is String {
                jsParams = params as! String
            }
        }
    }
    
    func hasHtmlCall(request: NSURLRequest) -> Bool {
        guard let requestURLString = request.URL?.absoluteString else {
            return false
        }
        
        return requestURLString.hasPrefix("js-call:")
    }
    
    private func callback(method: String, args:Dictionary<String, String>) {}
    
}